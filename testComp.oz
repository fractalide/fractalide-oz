% Some tests. feed the first paragraph and then the 3 at the end of the file.
declare
[Comp] = {Module.link ['lib/component.ozf']}
%% Even Comp
Even = {Comp.new comp(
		    inPorts(
		       port(name:input
			    procedure: proc {$ IP Out Var State} {Browse IP#' is an even number'} end
			   )
		       ))}
%% Odd Comp
Odd = {Comp.new comp(
		   inPorts(
		      port(name:input
			   procedure: proc {$ IP Out Var State} {Browse IP#' is an odd number'} end
			  )
		      ))}
%% Filter Comp
FIn1 = port(name:x procedure: proc{$ IP Out Var State} Var.x = IP end)
FIn2 = port(name:y procedure: proc{$ IP Out Var State} Var.y = IP end)
FIn3 = arrayPort(name:z
		 procedure: proc{$ IPs Out Var State}
			       Var.z = {FoldL IPs fun{$ Acc N} Acc+N end 0}
			    end
		)
Proc1 = proc {$ Out Var State} Tot in
	   Tot = (Var.x*Var.y) + Var.z
	   if Tot mod 2 == 0 then
	      {Out.even Tot}
	   else
	      {Out.odd Tot}
	   end
	end
Proc2 = proc {$ Out Var State}
	   {Browse 'It\'s the '#State.cpt#' computations'}
	   State.cpt := State.cpt + 1
	end
Filter = {Comp.new comp(
		      inPorts(FIn1 FIn2 FIn3)
		      outPorts(even odd)
		      procedures(Proc1 Proc2)
		      var(x y z)
		      state(cpt:1)
		      )}
{Filter addinArrayPort(z)} % Say the the array input port that we need two entries
{Filter addinArrayPort(z)}
{Filter bind(odd Odd input)} % Bind the component between them
{Filter bind(even Even input)}

%First test
{Filter send(x 2)}
{Filter send(y 5)}
{Filter send(z#1 3)}
{Filter send(z#2 3)}

{Filter changeProcPort(x proc {$ IP Out Var State} Var.x = IP*2 end )}


declare
[Comp] = {Module.link ['lib/component.ozf']}
Generator = {Comp.new comp(
			   procedures(
			      proc {$ Out Var State}
				 proc {Rec}
				    {Browse State.cpt}
				    State.cpt := State.cpt + 1
				    {Delay 3000}
				    {Rec}
				 end
			      in
				 {Rec}
			      end)
			   state(cpt:1)
			 )}

{Generator start}

{Generator stop}
