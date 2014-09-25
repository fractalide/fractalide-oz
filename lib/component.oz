/*
<one line to give the program's name and a brief idea of what it does.>
Copyright (C) 2014 Denis Michiels

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
functor
export
   new: NewStateComponent
define 
   /*
   * NewQueue : return a bounded buffer, as presented in CTM book
   * There is a max size, which represent the size of the buffer.
   * The get operation block the operation if the queue is empty
   */ 
   fun {NewQueue MaxSize}
      Given GivePort = {NewPort Given}
      Taken TakePort = {NewPort Taken}
      Size = {NewCell 0}
      Buffer = {NewCell nil}
      Max = MaxSize
      proc {Match Xs Ys}
	 case Xs # Ys
	 of (X|Xr) # (Y|Yr) then
	    X=Y
	    
	    {Match Xr Yr}
	 [] nil # nil then skip
	 end
      end
   in
      thread {Match Given Taken} end
      queue(put: proc{$ X Ack}
		    if @Size > Max then
		       Buffer := {Reverse X#Ack | {Reverse @Buffer}}
		    else
		       Size := @Size + 1
		       {Send GivePort X}
		       Ack = ack
		    end
		 end
	    get: proc{$ X}
		    Size := @Size - 1
		    {Send TakePort X}
		    {Wait X}
		    if @Size =< Max andthen @Buffer \= nil then Msg Ack in
		       Msg#Ack = (@Buffer).1
		       Buffer := (@Buffer).2
		       Size := @Size + 1
		       {Send GivePort Msg}
		       Ack = ack
		    end
		 end
	   size : fun{$} @Size end)
   end
   /*
   Return a new component. Several messages can be send to it.
   Example of component state : 
     component(name: aName
	       type: aType
	       description: "the description and documentation of the component"
	       inPorts:'in'(
			  name:port(q:AQueue)
			  name2:arrayPort(qs:queues(a:AQueue b:AnOtherQueue)
					  connect(a:2 b:1)
					  size:10
					  )
			  )
	       outPorts:out(name:nil
			    name2:arrayPort(1:nil
					    2:[comp#port comp2#port2])
			    ...)
	       procedure:Proc
	       state:{NewDictionary}
	       threads:Thread
	       options:opt(pre:'x' post:'y'))
   
   */
   fun {NewComponent NewState}
      Stream Point = {NewPort Stream}
      /*
      PrepareOut -
      PRE : OutPorts is a record representing the field outPorts of a component record
      POST : Return a record of procedure. There is a procedure for each outPort which the signature proc {$ Msg}. The Msg is send to each connected component. If the buffer of a receiving component is full, the operation is blocked.
      */
      fun {PrepareOut OutPorts}
	 {Record.map OutPorts
	  fun {$ Out}
	     if {Label Out} \= arrayPort then
		proc {$ Msg}				
		   for AOut in Out do C N Ack in 
		      C#N = AOut
		      {C send(N Msg Ack)}
		      {Wait Ack}
		   end
		end
	     else
		{Record.foldLInd Out
		 fun {$ Ind Acc List}
		    proc {P Msg}
		       for AOut in List do C N Ack in
			  C#N = AOut
			  {C send(N Msg Ack)}
			  {Wait Ack}
		       end
		    end
		 in
		    {Record.adjoinAt Acc Ind P}
		 end
		 outs
		}
	     end
	  end
	 }
      end
      /*
      PRE : InPorts is the inPorts field of the component record
      POST : A new record, where the labels are the port's name, and the value its buffer. 
      */
      fun {PrepareIns InPorts}
	 {Record.foldLInd InPorts
	  fun {$ Name Acc Port}
	     case Port
	     of port(q:Queue) then
		{Record.adjoinAt Acc Name Queue}
	     [] arrayPort(qs:Queues connect:_ size:_) then SubBuffer in
		SubBuffer = {Record.foldLInd Queues
			     fun{$ IndArray AccArray QueueArray}
				{Record.adjoinAt AccArray IndArray QueueArray}
			     end
			     subInBuffers()
			    }
		{Record.adjoinAt Acc Name SubBuffer}
	     end
	  end
	  inBuffers()
	 }
      end
      /*
      PRE : Opt is a record that represent the options field of a component record.
      POST : Return true if all the elements of Opt are binded, else otherwise.
      */
      fun {CheckOpt Opt}
	 fun {Rec Opts}
	    case Opts
	    of nil then true
	    [] X|Xr then
	       if {IsDet X} then {Rec Xr}
	       else false
	       end
	    end
	 end
      in
	 {Rec {Record.toList Opt}}
      end
      /*
      PRE : Receive all the input ports
      POST : Return true if there is at least one IP in at least one buffer
      */
      fun {CheckBuffers Bufs}
	 fun {CheckListB Buffers}
	    fun {Rec Ls}
	       case Ls
	       of nil then false
	       [] L|Lr then
		  if {L.size} > 0 then true
		  else {Rec Lr}
		  end
	       end
	    end
	 in
	    {Rec Buffers}
	 end
	 fun {RecCB Bs}
	    case Bs
	    of nil then false
	    [] B|Br then
	       if {Label B} == port then
		  if {B.q.size} > 0 then true
		  else {RecCB Br}
		  end
	       else
		  if {Record.width B.qs} == 0 orelse {CheckListB {Record.toList B.qs}} then true
		  else {RecCB Br}
		  end
	       end
	    end
	 end
      in
	 if {Record.width Bufs} == 0 then true
	 else {RecCB Bufs} end
      end
      thread
	 %Every messages send to the component is deal in this FoldL
	 {FoldL Stream
	  fun {$ State Msg}
	     /*
	     CheckSync - 
	     Return true if the component can start :
	       - all options are defined
	       - there is at least one IP in at least one port
	       - the previous execution is ended
	       - the run variable is true
			    
	     */
	     fun {CheckSync State}
		(State.threads == nil orelse {Thread.state State.threads} == terminated) andthen {CheckOpt State.options} andthen {CheckBuffers {Record.toList State.inPorts}} andthen State.run
	     end
	     /*
	     Exec -
             Launch the procedure for the components.
             PRE : State is record representing a component
             POST : Return a new state representing the same component, with the new value for the execution.
	     */			      
	     fun {Exec State} Sync in
	        % Look for sync
		Sync = {CheckSync State}
		if {Not Sync} then
		   State
		else Ins Out Th in
		   % Build a record with all the buffers of all input ports.
		   Ins = {PrepareIns State.inPorts}
		   % Build a procedure to send IP to the output ports. 
		   Out = {PrepareOut State.outPorts}
		   thread
		      Th = {Thread.this}
		      try
			 {State.procedure Ins Out State}
		      catch E then
			 {Out.'ERROR' component_exception(name:State.name type:State.type error:E entryPoint:State.entryPoint)}
		      end
		      if {Record.width State.inPorts} > 0 then
			 {Send Point exec} %Restart
		      end
		   end
		   % Return the new state, with the thread
		   {Record.adjoinList State [threads#Th]}
		end
	     end
	  in
	     % Deal with the different messages
	     case Msg
	     % Operation on the component
	     of getState(?R) then R=State State
	     [] setState(NState) then NState
	     [] start then NState in
		NState = {Record.adjoinAt State run true}
		{Exec NState}
	     [] exec then
		{Exec State}
	     [] stop then
		if State.threads \= nil andthen {Thread.state State.threads} \= terminated then {Thread.terminate State.threads} end
		{Record.adjoinAt State run false}
	     [] getInPort(Port ?R) then
		R=State.inPorts.Port
		State
	     [] getOutPort(Port ?R) then
		R=State.outPorts.Port
		State
	     [] setParentEntryPoint(ParentEntryPoint) then
		{Record.adjoinAt State parentEntryPoint ParentEntryPoint}
	     [] connect(Port Index) then NewArrayPort in 
		NewArrayPort = if {Not {HasFeature State.inPorts.Port.qs Index}} then NQS NC in
				  NQS = {Record.adjoinAt State.inPorts.Port.qs Index {NewQueue State.inPorts.Port.size}}
				  NC = {Record.adjoinAt State.inPorts.Port.connect Index 1}
				  {Record.adjoinList State.inPorts.Port [qs#NQS connect#NC]}
			       else NC in
				  NC = {Record.adjoinAt State.inPorts.Port.connect Index State.inPorts.Port.connect.Index+1}
				  {Record.adjoinAt State.inPorts.Port connect NC}
			       end
		{NestedRecord adjoinAt State [inPorts Port] NewArrayPort}
	     [] disconnect(Port Index) then NewArrayPort in
		NewArrayPort = if State.inPorts.Port.connect.Index == 1 then NQS NC in
				  NQS = {Record.subtract State.inPorts.Port.qs Index}
				  NC = {Record.subtract State.inPorts.Port.connect Index}
				  {Record.adjoinList State.inPorts.Port [qs#NQS connect#NC]}
			       else NC in
				  NC = {Record.adjoinAt State.inPorts.Port.connect Index State.inPorts.Port.connect.Index-1}
				  {Record.adjoinAt State.inPorts.Port connect NC}
			       end
		{NestedRecord adjoinAt State [inPorts Port] NewArrayPort}
	     % Interact with the component
	     [] send(InPort#N Msg Ack) then
		if {HasFeature State.inPorts InPort} andthen {HasFeature State.inPorts.InPort.qs N} then
		   {State.inPorts.InPort.qs.N.put Msg Ack}
		   {Exec State}
		else Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_send_array(dest:InPort#N state:State name:State.name type:State.type)}
		   Ack = ack
		   State
		end
	     [] send('START' _ Ack) then
		Ack = ack
		{Exec State}
	     [] send('STOP' _ Ack) then
		Ack = ack
		if State.threads \= nil andthen {Thread.state State.threads} \= terminated then {Thread.terminate State.threads} end
		State
	     [] send(options Msg Ack) then NOptions NState in
		Ack = ack
		NOptions = {Record.adjoinList State.options {Record.toListInd Msg}}
		NState = {Record.adjoinAt State options NOptions}
		if {Record.width State.inPorts} > 0 then {Exec NState} else NState end
	     [] send(InPort Msg Ack) then
		if {HasFeature State.inPorts InPort} then
		   {State.inPorts.InPort.q.put Msg Ack}
		   {Exec State}
		else Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_send(state:State name:State.name type:State.type)}
		   Ack = ack
		   State
		end
	     [] bind(OutPort#N Comp Name) then NAPort in
		try
		   if {HasFeature Name 2} then {Comp connect(Name.1 Name.2)} end
		   if {HasFeature State.outPorts.OutPort N} then
		      NAPort = Comp#Name | State.outPorts.OutPort.N
		   else
		      NAPort = Comp#Name | nil
		   end
		   {NestedRecord adjoinAt State [outPorts OutPort N] NAPort}
		catch E then Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_bind_array(error:E state:State name:State.name type:State.type)}
		   State
		end
	     [] bind(OutPort Comp Name) then NPort in
		try
		   if {HasFeature Name 2} then {Comp connect(Name.1 Name.2)} end
		   NPort = Comp#Name | State.outPorts.OutPort
		   {NestedRecord adjoinAt State [outPorts OutPort] NPort}
		catch E then Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_bind(error:E state:State name:State.name type:State.type)}
		   State
		end
	     [] unBound(OutPort#Sub Comp) then NAPort NPort in
		try
		   if {HasFeature State.outPorts.OutPort Sub} then
		      NAPort = {FoldL State.outPorts.OutPort.Sub
				fun {$ Acc P}
				   if Comp == P.1 then
				      if {HasFeature P.2 2} then {Comp disconnect(P.2.1 P.2.2)} end
				      Acc
				   else P|Acc end
				end
				nil
			       }
		      if NAPort \= nil then
			 NPort = {Record.adjoinAt State.outPorts.OutPort Sub NAPort}
		      else
			 NPort = {Record.subtract State.outPorts.OutPort Sub}
		      end
		      {NestedRecord adjoinAt State [outPorts OutPort] NPort}
		   else
		      State
		   end
		catch E then Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_unBound(error:E state:State name:State.name type:State.type)}
		   State
		end
	     [] unBound(OutPort Comp) then NPort in
		try
		   NPort = {FoldL State.outPorts.OutPort
			    fun {$ Acc P}
			       if Comp == P.1 then
				  if {HasFeature P.2 2} then {Comp disconnect(P.2.1 P.2.2)} end
				  Acc
			       else P|Acc end
			    end
			    nil
			   }
		   {NestedRecord adjoinAt State [outPorts OutPort] NPort}
		catch E then Out in
		   Out = {PrepareOut State.outPorts}
		   {Out.'ERROR' cannot_unBound(error:E state:State name:State.name type:State.type)}
		   State
		end
	     end
	  end
          % The accumulator
	  NewState
          % The return value (not needed?)
	  _
	 }
      end
      P
   in
      P = proc {$ Msg} {Send Point Msg} end
      NewState.entryPoint = P
      P
   end
   %% Functions to build a new component
   fun {InPorts In}
      {Record.foldL In
       fun {$ Acc P} Size in
	  Size = if {HasFeature P size} then P.size else 25 end
	  {Record.adjoinAt Acc {Label P} port(q:{NewQueue Size})}
       end
       'in'()
      }
   end
   fun {InArrayPorts In}
      {Record.foldL In
       fun {$ Acc P} Size in
	  Size = if {HasFeature P size} then P.size else 25 end
	  {Record.adjoinAt Acc {Label P} arrayPort(qs:queues() connect:c() size:Size)}
       end
       'arrayIn'()
      }
   end
   fun {OutPorts Out}
      {Record.foldL Out
       fun {$ Acc E}
	  {Record.adjoinAt Acc E nil}
       end
       out()
      }
   end
   fun {OutArrayPorts Out}
      {Record.foldL Out
       fun {$ Acc E}
	  {Record.adjoinAt Acc E arrayPort()}
       end
       arrayOut()
      }
   end
   fun {BuildNState St} D in
      D = {NewDictionary}
      {Record.forAllInd St
       proc {$ N V} D.N := V end
      }
      D
   end
   fun {NewState Name Type GivenRecord}
      DefaultState NState in
      DefaultState = component(name:Name type:Type description:_
			       inPorts:'in'() outPorts:out('ERROR':nil)
			       procedure:nil state:{NewDictionary}
			       threads:nil options:opt()
			       run:true entryPoint:_ parentEntryPoint:nil
			      )
      NState = {Record.foldLInd GivenRecord
		fun {$ Ind S Rec}
		   case {Record.label Rec}
		   of inPorts then {Record.adjoinAt S inPorts {Record.adjoin S.inPorts {InPorts Rec}}}
		   [] inArrayPorts then {Record.adjoinAt S inPorts {Record.adjoin S.inPorts {InArrayPorts Rec}}}
		   [] outPorts then {Record.adjoinAt S outPorts {Record.adjoin S.outPorts {OutPorts Rec}}}
		   [] outArrayPorts then {Record.adjoinAt S outPorts {Record.adjoin S.outPorts {OutArrayPorts Rec}}}
		   [] procedure then {Record.adjoinAt S procedure Rec.1}
		   [] state then {Record.adjoinAt S state {BuildNState Rec}}
		   [] options then {Record.adjoinAt S options Rec}
		   else
		      if Ind == description then {Record.adjoinAt S description Rec}
		      else raise unknown_arg(Ind Rec S) end end
		   end
		end
		DefaultState
	       }
      if {Not {IsDet NState.description}} then raise component_description_not_defined(NState) end end
      NState
   end
   fun {NewStateComponent Name Type ARecord}
      {NewComponent {NewState Name Type ARecord}}
   end
   /*
   PRE: Action is an understable method of {Record.}, Init is the initial record, List is a list of features, Value is the new value
   POST: A new record where the action is done on the last element of the list with the value. If the action require no value, it must be set at undefined
   */
   fun {NestedRecord Action Init List Value}
      fun {Rec Ls R}
	 case Ls
	 of L|nil then
	    if {IsDet Value} then 
	       {Record.Action R L Value}
	    else
	       {Record.Action R L}
	    end
	 [] L|Lr then
	    {Record.adjoinAt R L {Rec Lr R.L}}
	 end
      end
   in
      {Rec List Init}
   end
end
	 