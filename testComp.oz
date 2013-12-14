% Some tests. feed the first paragraph and then the 3 at the end of the file.
declare
[Comp] = {Module.link ['lib/component.ozf']}
% NewQueue will be totatly hide for the user
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
%This state of a component had 1 input port, and simply browse the IP
Display = component(inPorts:'in'(input:port(q:{NewQueue} % The buffer of the port, will be hidden for the user
					    p:proc {$ IP Out Var State} {Browse 1#IP} end % The procedure to deal with the IP
					    s:nil % Use for synchronization, will be hidden for the user
					   )
				) % A record with all the input ports (can be simple or array)
		    outPorts:out % A record with all the output ports (no here)
		    procs:procs  % A record with all the independant procedure (no here)
		    var:var      % The shared variables between the procedures (unique assignement)
		    state:{NewDictionary}
		   )
C = {Comp.new} % create a componenet
{C changeState(Display)} % Load the state that we just create
% Nearly the same, just to distinguish the two
Display2 = component(inPorts:'in'(input:port(q:{NewQueue}
					     p:proc {$ IP Out Var State}
						  {Browse State.cpt#IP}
						  State.cpt := State.cpt + 1
					       end
					     s:nil
					    )
				 )
		     outPorts:out
		     procs:procs
		     var:var
		     state:{NewDictionary}
		    )
Display2.state.cpt := 0
C2 = {Comp.new}
{C2 changeState(Display2)}
% This component do :  x*y + sum(z). There is 3 shared variable between the procedure x, y and z. The input ports load these values, and the proc in procs make the calcul.
Mul = component(inPorts:'in'(x:port(q:{NewQueue}
				    p:proc{$ IP Out Var State} {Browse begin} Var.x = IP end
				    s:nil)
			     y:port(q:{NewQueue}
				    p:proc{$ IP Out Var State} Var.y = IP end
				    s:nil)
			     z:arrayPort(qs:queues()
					 p:proc{$ IPs Out Var State} Var.z = {FoldR IPs fun{$ E Acc} E+Acc end 0} end
					 s:[nil])
			    )
		outPorts:out(output:nil)
		procs:procs(proc {$ Out Var State}
			       {Browse beginOut}
			       {Wait Var.x} % Wait is use to see if the Var is set by another proc
			       {Wait Var.y}
			       {Wait Var.z}
			       {Out.output Var.z + Var.x*Var.y}
			    end)
		var:var(x:_ y:_ z:_)
		state:{NewDictionary}
	       )
D = {Comp.new}
{D changeState(Mul)}
{D addinArrayPort(z)} % Say the the array input port that we need two entries
{D addinArrayPort(z)}
{D bind(output C input)} % Bind the component between them
{D bind(output C2 input)}

%First test
{D send(x 7)}
{D send(y 1)}
{D send(z#1 1)}
{D send(z#2 2)}

%Second test. A procedure is change while the sync is not ready, so it has no effect
{D send(x 7)}
{D send(x 7)}
{D send(y 1)}
{D changeProcPort(x proc {$ IP Out Var State} {Browse begin2} Var.x = 2*IP end)}
{D send(z#1 1)}
{D send(z#2 2)}

%Third test. The new procedure is executed!
{D send(y 1)}
{D send(z#1 1)}
{D send(z#2 2)}
