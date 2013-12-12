% component(
%    inPorts:in(x:port(q:Queue
% 	       f:Fun)
% 	y:arrayPort(qs:buffer(Q1 Q2 Q3)
% 		    f: Fun)
%        )
%    outPorts(even:port(Comp#Name)
%        odd:port(C1#N1 C2#N2 C3#N3)
%       )
%    funs:funs(F1 F2 F3)
%    state:State
%    sync:Sync
%    )

declare
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
fun {NewComponent}
   Stream Point = {NewPort Stream} in
   thread
      {FoldL Stream
       fun {$ State Msg}
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
	  fun {Exec State} Sync in
	     % Look for sync
	     Sync = {CheckSync State.inPorts}
	     {Browse sync#Sync}
	     if {Not Sync} then
		State
	     else NVar NInPorts Out in %All port can receive the next IP
		NInPorts = {Record.map State.inPorts fun {$ Port} {Record.adjoinAt Port s _} end}
		NVar = {Record.map State.var fun{$ _} _ end}
		Out = {Record.map State.outPorts
		       fun {$ Out}
			  proc {$ Msg} C N in C#N = @Out {C send(N Msg)} end
		       end
		      }
		{Record.forAll NInPorts
		 proc {$ Port}
		    case Port
		    of port(q:Queue p:Proc s:Sync) then IP in
		       IP = {Queue.get}
		       thread {Proc IP Out NVar} end
		       Sync = IP
		    [] arrayPort(qs:Qs p:Proc s:Sync) then IPs in
		       IPs = {Record.foldR Qs fun{$ E Acc} {E.get}|Acc end nil}
		       thread {Proc IPs Out NVar} end
		       Sync = IPs
		    end
		 end
		}
		for Proc in {Arity State.procs} do
		   thread {State.procs.Proc Out NVar} end
		end
		{Record.adjoinAt {Record.adjoinAt State var NVar} inPorts NInPorts}
	     end
	  end
       in
	  case Msg
	  % Operation on the component
	  of getState(?R) then R=State State
	  [] changeState(NState) then NState
	  [] getPort(Port ?R) then R=State.inPorts.Port State
	  [] bind(OutPort Comp Name) then (State.outPorts.OutPort) := Comp#Name State
	  % Interact with the component
	  [] send(InPort#N Msg) then
	     {State.inPorts.InPort.qs.N.put Msg}
	     {Exec State}
	  [] send(InPort Msg) then
	     {State.inPorts.InPort.q.put Msg}
	     {Exec State}
	  end
       end
       %Acc
       component(inPorts:'in'() outPorts:out() procs:procs() var:var() sync:sync())
       %Return value (not needed?)
       _
      }
   end
   proc {$ Msg} {Send Point Msg} end
end

declare
A = {NewQueue}
{A.put 1}
{Browse A}

declare
Display = component(inPorts:'in'(input:port(q:{NewQueue}
					   p:proc {$ IP Out Var} {Browse IP} end
					   s:nil
					  )
			       )
		    outPorts:out
		    procs:procs
		    var:var
		   )
C = {NewComponent}
{C changeState(Display)}
Mul = component(inPorts:'in'(x:port(q:{NewQueue} p:proc{$ IP Out Var} {Browse begin} Var.x = IP end s:nil)
			     y:port(q:{NewQueue} p:proc{$ IP Out Var} Var.y = IP end s:nil)
			     z:arrayPort(qs:queues({NewQueue} {NewQueue}) p:proc{$ IPs Out Var} Var.z = {FoldR IPs fun{$ E Acc} E+Acc end 0} end s:[nil])
			    )
		outPorts:out(output:{NewCell nil})
		procs:procs(proc {$ Out Var} {Browse beginOut} {Wait Var.x} {Wait Var.y} {Wait Var.z} {Out.output Var.z + Var.x*Var.y} end)
		var:var(x:_ y:_ z:_)
	       )
D = {NewComponent}
%{Browse {C getState($)}}
{D changeState(Mul)}
{D bind(output C input)}

{Inspect {C getState($)}}

{C send(input 5)}

{Browse {D getPort(z $)}}



{D send(x 7)}
{D send(y 1)}

{D send(z#1 1)}
{D send(z#2 2)}

{Browse {FoldR [1 2 3] fun{$ E Acc} E+Acc end 0}}


{Browse {C getPort(x $)}}
{Browse {C getPort(y $)}}

{C print}

declare
proc {Test R P}
   {Wait R.a}
   {Send P R.a}
end

declare
A = {NewQueue}
B = {NewQueue}
{Browse {B.get}}
{A.put 1}
{B.put 2}
{Browse {A.get}}

{Send P k}

A.a = 3

declare
A = r(a:12 b:134 c:43)
{Record.forAll A
	 proc {$ E} {Browse E} end}

fun {Test A} OK in
   OK = true
   for S in {Arity A} do
      if {Not {IsDet A.S}} then OK = false end
   end
   OK
end

if {Not {IsDet A.a}} then {Browse true} else {Browse false} end

declare
A = r(a:12 b:35 d:12)
{Browse A}
{Browse {Record.map A fun {$ E} E*2 end}}


{Browse {Record.foldR A
	 fun{$ E Acc}
	    E|Acc
	 end
	 nil
	}}

{Record.fdsq _}

declare
A = _
{Wait A}

A = r(1:_ 2:32)
B = A
{Browse A}
{Browse B}
A.1 = 1

A = 1

{Browse {IsDet [_]}}