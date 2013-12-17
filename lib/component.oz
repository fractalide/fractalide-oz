functor
export
   new: NewStateComponent
define
   % NewQueue : return a bounded buffer, as presented in CTM book
   fun {NewQueue}
      Given GivePort = {NewPort Given}
      Taken TakePort = {NewPort Taken}
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
      queue(put: proc{$ X} {Send GivePort X} end
	    get: proc{$ X} {Send TakePort X} end)
   end
   % Return a new component. Several messages can be send to it.
   fun {NewComponent NewState}
      Stream Point = {NewPort Stream} 
      thread
	 %Every emssage is deal in this FoldL
	 {FoldL Stream
	  fun {$ State Msg}
	     % Return true if all inPorts are synchronized. That means every inPorts have received one IP.
	     % A port that is synchronized is a port that is ready to receive the next IP.
	     % We see that a port is synchronized when the 's' selection on the port record is determine.
	     fun {CheckSync InPorts}
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
	     in
		{CheckSyncRec {Record.toList InPorts}}
	     end
	     % Lauch every procedures for the componenet : inPorts procedures (to deal with single IP) and independant procedures.
	     % That appends only if all the state are synchronized.
	     fun {Exec State} Sync in
	        % Look for sync
		Sync = {CheckSync State.inPorts}
		if {Not Sync} then
		   State 
		else NVar NInPorts Out Th1 Th2 in %All port can receive the next IP
		   % Restart the sync, the 's' selection is now undefined
		   NInPorts = {Record.map State.inPorts fun {$ Port} {Record.adjoinAt Port s _} end}
		   % Put at undefined the variables that are common to all procedures
		   NVar = {Record.map State.var fun{$ _} _ end}
		   % Build a procedure to send IP to the output ports.
		   Out = {Record.map State.outPorts
			  fun {$ Out}
			     proc {$ Msg} 
				for AOut in Out do C N in 
				   C#N = AOut
				   {C send(N Msg)}
				end
			     end
			  end
			 }
		   % Launch every ports procedures, keeping the thread.
		   Th1 = {Record.foldL NInPorts
			  fun {$ Acc Port} IPs T in
			     case Port
			     of port(q:Queue p:_ s:_) then
				IPs = {Queue.get}
			     [] arrayPort(qs:Qs p:_ s:_) then
				IPs = {Record.foldR Qs fun{$ E Acc} {E.get}|Acc end nil}
			     end
			     thread
				T = {Thread.this}
				{Port.p IPs Out NVar State.state State.options}
			     end
			     Port.s = IPs
			     T|Acc
			  end
			  nil
			 }
		   % Launch every independant procedures, keeping the thread.
		   Th2 = {FoldL {Arity State.procs}
			  fun {$ Acc Proc} T in
			     thread
				T = {Thread.this}
				{State.procs.Proc Out NVar State.state State.options}
			     end
			     T|Acc
			  end
			  Th1
			 }
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
		for T in State.threads do {Thread.terminate T} end
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
	     [] send(InPort#N Msg) then
		{State.inPorts.InPort.qs.N.put Msg}
		{Exec State}
	     [] send(options Msg) then NOptions in 
		NOptions = {Record.adjoinList State.options {Record.toListInd Msg}}
		{Record.adjoinAt State options NOptions}
	     [] send(InPort Msg) then
		{State.inPorts.InPort.q.put Msg}
		{Exec State}
	     [] bind(OutPort Comp Name) then NPort NOutPorts in
		NPort = Comp#Name | State.outPorts.OutPort
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
      {Record.foldL Out
       fun {$ Acc E}
	  {Record.adjoinAt Acc E nil}
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
end

	 