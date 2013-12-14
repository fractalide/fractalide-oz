functor
export
   new: NewComponent
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
   fun {NewComponent}
      Stream Point = {NewPort Stream} 
      thread
	 %Every emssage is deal in this FoldL
	 {FoldL Stream
	  fun {$ State Msg}
	     % Return true if all inPorts are synchronized. That means every inPorts have received one IP. 
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
		else NVar NInPorts Out in %All port can receive the next IP
		   % Restart the sync
		   NInPorts = {Record.map State.inPorts fun {$ Port} {Record.adjoinAt Port s _} end}
		   % Put at undefined the variables for the sync
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
		   % Launch every ports procedures.
		   {Record.forAll NInPorts
		    proc {$ Port}
		       case Port
		       of port(q:Queue p:Proc s:Sync) then IP in
			  IP = {Queue.get}
			  thread {Proc IP Out NVar State.state} end
			  Sync = IP
		       [] arrayPort(qs:Qs p:Proc s:Sync) then IPs in
			  IPs = {Record.foldR Qs fun{$ E Acc} {E.get}|Acc end nil}
			  thread {Proc IPs Out NVar State.state} end
			  Sync = IPs
		       end
		    end
		   }
		   % Launch every independant procedures.
		   for Proc in {Arity State.procs} do
		      thread {State.procs.Proc Out NVar State.state} end
		   end
		   % Return the new state, with the new var record and the new inPorts record.
		   {Record.adjoinAt {Record.adjoinAt State var NVar} inPorts NInPorts}
		end
	     end
	  in
	     % Deal with the different messages
	     case Msg
	     % Operation on the component
	     of getState(?R) then R=State State
	     [] changeState(NState) then NState
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
	  component(inPorts:'in'() outPorts:out() procs:procs() var:var() sync:sync() state:{NewDictionary})
          % The return value (not needed?)
	  _
	 }
      end
      proc {$ Msg} {Send Point Msg} end
   end
end

	 