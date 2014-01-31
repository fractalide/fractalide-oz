functor
export
   new: NewStateComponent
   setProcedureInPort: SetProcedureInPort
   resetInPort: ResetInPort
   setNameInPort: SetNameInPort
define
   /*
   * NewThread - CTM p382
   * Thread abstraction with termination detection
    */
   local
      proc {ZeroExit N Is}
	 case Is of I|Ir then
	    if N+I \= 0 then {ZeroExit N+I Ir} end
	 end
      end
   in
      proc {NewThread P ?SubThread}
	 Is Pt = {NewPort Is}
      in
	 proc {SubThread P}
	    {Send Pt 1}
	    thread
	       {P} {Send Pt ~1}
	    end
	 end
	 {SubThread P}
	 {ZeroExit 0 Is}
      end
   end
   /*
   * NewQueue : return a bounded buffer, as presented in CTM book
   * There is a max size, which represent the size of the buffer.
   */ 
   fun {NewQueue}
      Given GivePort = {NewPort Given}
      Taken TakePort = {NewPort Taken}
      Size = {NewCell 0}
      Buffer = {NewCell nil}
      Max = 20
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
		    if @Size =< Max andthen @Buffer \= nil then Msg Ack in
		       Msg#Ack = (@Buffer).1
		       Buffer := (@Buffer).2
		       Size := @Size + 1
		       {Send GivePort Msg}
		       Ack = ack
		    end
		 end)
   end
   /*
   Return a new component. Several messages can be send to it.
   Example of component state : 
     component(inPorts:'in'(
			  name:port(q:AQueue
				    procedure:AProc
				    s:_)
			  name2:arrayPort(q:queues(AQueue AnOtherQueue)
					  procedure:Proc
					  s:[_])
			  )
	       outPorts:out(name:port(nil)
			    name2:arrayPort(1:nil
					    2:[comp#port comp2#port2])
			    ...)
	       procs:procs(Proc1 Proc2)
	       var:var(x:_ y:_ z:_)
	       state:{NewDictionary}
	       threads:[Thread1 Thread2 Thread3]
	       options:opt(pre:'x' post:'y'))
   
   */
   fun {NewComponent NewState}
      Stream Point = {NewPort Stream} 
      thread
	 %Every messages send to the component is deal in this FoldL
	 {FoldL Stream
	  fun {$ State Msg}
	     /*
	     CheckSync - 
	     Return true if all inPorts are synchronized.
	     A port that is synchronized if a it's ready to receive the next IP (last execution is terminated).
             At least one port must have an IP in its buffer.
			    PRE : State is a record that represent a component
			    POST : True if the component has terminate the last execution and there is at least one IP in a port buffer,
			           False otherwise.
			    
	     */
	     fun {CheckSync State}
		/*
		PRE : Xs is a list corresponding to the inPorts field of a component record in a list form.
		POST : return true if all s field is determined, else otherwise
		*/
		fun {CheckSyncRec Xs}
		   case Xs
		   of nil then true
		   [] port(q:_ p:_ s:S)|Xr then
		      if {IsDet S} then {CheckSyncRec Xr}
		      else false
		      end
		   [] arrayPort(qs:_ p:_ s:S)|Xr then OK in
		      OK = {FoldR S fun{$ X Acc}
				       if {IsDet X} then Acc
				       else false end end
			    true}
		      if OK then {CheckSyncRec Xr}
		      else false end
		   end
		end
		/*
		PRE : Threads is a list corresponding to the threads field of a component record
	        POST : Return true if all the thread are terminated, else otherwise
		*/						       
		fun {CheckThread Threads}
		   fun {Rec Threads}
		      case Threads
		      of nil then true
		      [] T|Ts then
			 if {Thread.state T} == terminated then
			    {CheckThread Ts}
			 else
			    false
			 end
		      end
		   end
		in
		   if Threads == threads then true
		   else {Rec Threads} end
		end
		P T
	     in
		P = {CheckSyncRec {Record.toList State.inPorts}}
		T = {CheckThread State.threads}
		P andthen T
	     end
	     /*
	     Exec -
             Launch every procedures for the components : port procedures and independant procedures.
             PRE : State is record representing a component
             POST : Return a new state representing the same component, with the new value for the execution.
		    If the ports are synchronized, The fields that change are the 's' field in inPorts field, the var field, the threads field.
		    Else, the record is unchanged.
	     */			      
	     fun {Exec State} Sync in
	        % Look for sync
		Sync = {CheckSync State}
		if {Not Sync} then
		   State 
		else NVar NInPorts Out Th1 Th2 SubThread in %All port can receive the next IP
		   % Restart the sync, the 's' selection is now undefined
		   NInPorts = {Record.map State.inPorts fun {$ Port} {Record.adjoinAt Port s _} end}
		   % Put at undefined the variables that are common to all procedures
		   NVar = {Record.map State.var fun{$ _} _ end}
		   % Build a procedure to send IP to the output ports. 
		   Out = {Record.map State.outPorts
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
		   thread
		      {NewThread proc {$} 
		                 % Launch every ports procedures, keeping the thread.
				    Th1 = {Record.foldL NInPorts
					   fun {$ Acc Port} IPs T in
					      case Port
					      of port(q:Queue p:_ s:_) then
						 IPs = {Queue.get}
					      [] arrayPort(qs:Qs p:_ s:_) then
						 IPs = {Record.foldR Qs fun{$ E Acc} {E.get}|Acc end nil}
					      end
					      {SubThread proc{$}
							    proc {Rec Stream} S in
							       {Port.p IPs Out NVar State.state State.options}
							       case {Label IPs}
							       of begin then S = Stream+1
							       [] 'end' then S =  Stream-1
							       else S = Stream
							       end
							       if S \= 0 then {Rec S} end
							    end
							 in
							    T = {Thread.this}
							    {Rec 0}
							 end
					      }
					      Port.s = IPs
					      T|Acc
					   end
					   nil
					  }
		   % Launch every independant procedures, keeping the thread.
				    Th2 = {FoldL {Arity State.procs}
					   fun {$ Acc Proc} T in
					      {SubThread proc{$}
							    T = {Thread.this}
							    {State.procs.Proc Out NVar State.state State.options}
							 end
					      }
					      T|Acc
					   end
					   Th1
					  }
				 end
		       SubThread }
		      if {Record.width State.inPorts} > 0 then
			 {Send Point start}
		      end
		   end
		   % Return the new state, with the new var record and the new inPorts record.
		   {Record.adjoinList State [var#NVar inPorts#NInPorts threads#Th2]}
		end
	     end
	  in
	     % Deal with the different messages
	     case Msg
	     % Operation on the component
	     of getState(?R) then R=State State
	     [] changeState(NState) then NState
	     [] start then {Exec State}
	     [] stop then
		for T in State.threads do
		   if {Thread.state T} \= terminated then
		      {Thread.terminate T}
		   end
		end
		State
	     [] getInPort(Port ?R) then
		R=State.inPorts.Port
		State
	     [] getOutPort(Port ?R) then
		R=State.outPorts.Port
		State
	     [] addinArrayPort(Port) then NPort NInPorts NextId Ar in
		Ar = {Arity State.inPorts.Port.qs}
		NextId = if Ar == nil then 1 else {List.last Ar}+1 end
		NPort = {Record.adjoinAt State.inPorts.Port qs {Record.adjoinAt State.inPorts.Port.qs NextId {NewQueue}}}
		NInPorts = {Record.adjoinAt State.inPorts Port NPort}
		{Record.adjoinAt State inPorts NInPorts}
	     [] changeProcPort(Port Proc) then NPort NInPorts in
		NPort = {Record.adjoinAt State.inPorts.Port p Proc}
		NInPorts = {Record.adjoinAt State.inPorts Port NPort}
		{Record.adjoinAt State inPorts NInPorts}
	     % Interact with the component
	     [] send(InPort#N Msg Ack) then
		{State.inPorts.InPort.qs.N.put Msg Ack}
		{Exec State}
	     [] send(options Msg Ack) then NOptions in 
		NOptions = {Record.adjoinList State.options {Record.toListInd Msg}}
		Ack = ack
		{Record.adjoinAt State options NOptions}
	     [] send(InPort Msg Ack) then
		{State.inPorts.InPort.q.put Msg Ack}
		{Exec State}
	     [] bind(OutPort#N Comp Name) then NAPort NPort NOutPorts in
		try
		   NAPort = Comp#Name | State.outPorts.OutPort.N
		catch _ then
		   NAPort = Comp#Name | nil
		end
		NPort = {Record.adjoinAt State.outPorts.OutPort N NAPort}
		NOutPorts = {Record.adjoinAt State.outPorts OutPort NPort}
		{Record.adjoinAt State outPorts NOutPorts}
	     [] bind(OutPort Comp Name) then NPort NOutPorts in
		NPort = Comp#Name | State.outPorts.OutPort
		NOutPorts = {Record.adjoinAt State.outPorts OutPort NPort}
		{Record.adjoinAt State outPorts NOutPorts}
	     [] unBound(OutPort#Sub N) then NAPort NPort NOutPorts in
		NAPort = {Record.subtract State.outPorts.OutPort.Sub N}
		NPort = {Record.adjoinAt State.outPorts.OutPort Sub NAPort}
		NOutPorts = {Record.adjoinAt State.outPorts OutPort NPort}
		{Record.adjoinAt State outPorts NOutPorts}
	     [] unBound(OutPort N) then NPort NOutPorts in
		NPort = {Record.subtract State.outPorts.OutPort N}
		NOutPorts = {Record.adjoinAt State.outPorts OutPort NPort}
		{Record.adjoinAt State outPorts NOutPorts}
	     end
	  end
          % The accumulator
	  NewState
          % The return value (not needed?)
	  _
	 }
      end
   in
      proc {$ Msg} {Send Point Msg} end
   end
   %% Functions to build a new component
   fun {InPorts In}
      {Record.foldL In
       fun {$ Acc E}
	  case E
	  of port(name:N procedure:P) then
	     {Record.adjoinAt Acc N port(q:{NewQueue} p:P s:nil)}
	  [] arrayPort(name:N procedure:P) then
	     {Record.adjoinAt Acc N arrayPort(qs:queues() p:P s:[nil])}
	  end
       end
       'in'()
      }
   end
   fun {OutPorts Out}
      {Record.foldLInd Out
       fun {$ Ind Acc E}
	  case E
	  of port then 
	     {Record.adjoinAt Acc Ind nil}
	  [] arrayPort then
	     {Record.adjoinAt Acc Ind arrayPort}
	  end
       end
       out()
      }
   end
   fun {Var Vars}
      {Record.foldL Vars
       fun {$ Acc E}
	  {Record.adjoinAt Acc E _}
       end
       var()
      }
   end
   fun {NState St} D in
      D = {NewDictionary}
      {Record.forAllInd St
       proc {$ N V} D.N := V end
      }
      D
   end
   fun {NewState GivenRecord}
      DefaultState in
      DefaultState = component(inPorts:'in'() outPorts:out() procs:procs() var:var() state:{NewDictionary} threads:threads() options:opt())
      {Record.foldL GivenRecord
       fun {$ S Rec}
	  case {Record.label Rec}
	  of inPorts then {Record.adjoinAt S inPorts {InPorts Rec}}
	  [] outPorts then {Record.adjoinAt S outPorts {OutPorts Rec}}
	  [] procedures then {Record.adjoinAt S procs Rec}
	  [] var then {Record.adjoinAt S var {Var Rec}}
	  [] state then {Record.adjoinAt S state {NState Rec}}
	  [] options then {Record.adjoinAt S options Rec}
	  end
       end
       DefaultState
      }
   end
   fun {NewStateComponent ARecord}
      {NewComponent {NewState ARecord}}
   end
   %Function to modify a state
   %General function
   fun {ChangeState List Val State}
      fun {ChangeStateRec Xs S}
	 case Xs
	 of nil then Val
	 [] X|Xr then
	    {AdjoinAt S X {ChangeStateRec Xr S.X}}
	 end
      end
   in
      {ChangeStateRec List State}
   end
   fun {SetProcedureInPort State Port Proc}
      {ChangeState [inPorts Port procedure] Proc State}
   end
   fun {ResetInPort State Port}
      % TODO
      State
   end
   fun {SetNameInPort State Port Name} NState in
      NState = {ChangeState [inPorts Name] State.inPorts.Port State}
      {Record.adjoinAt NState inPorts {Record.subtract NState.inPorts Port}}
   end
   % fun {AddInPort State Port}
   %    case Port
   %    of port(name:N procedure:P) then
   % 	 {ChangeState [inPorts N] port(q:{NewQueue} p:P s:nil) State}
   %    [] arrayPort(name:N procedure:P) then
   % 	 {ChangeState [inPorts N] port(qs:queues() p:P s:[nil]) State}
   %    end
   % end
   % fun {RemoveInPort State Port}
   %    {Record.adjoinAt State inPorts {Record.subtract State.inPorts Port}}
   % end
   % fun {AddOutPort State Port}
   %    {ChangeState  [outPorts Port] nil State}
   % end
   % fun {RemoveOutPort State Port}
   %    {Record.adjoinAt State outPorts {Record.subtract State.outPorts Port}}
   % end
   % %% Have to name Procedure to do it correctly
   % fun {AddProc State Proc}
   %    {ChangeState [procedures] Proc State}
   % end
   % fun {RemoveProc State Proc}
   %    %TODO
   %    State
   % end
   % fun {AddVar State Var}
   %    {ChangeState [var Var] _ State}
   % end
   % fun {RemoveVar State Var}
   %    {Record.adjoinAt State var {Record.subtract State.var Var}}
   % end
end
	 