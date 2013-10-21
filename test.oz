declare
[Component] = {Module.link ["./lib/component.ozf"]}

%declare Three componenet
Even = {Component.new
	[input] %Input ports : input
	nil % No output ports
	proc{$ In Out} {Browse In.input # ' is an even Number'} end % The proc to apply
       }
Odd = {Component.new
       [input]
       nil
       proc{$ In Out} {Browse In.input # ' is an odd number'} end
      }
Filter = {Component.new
	  [a b]
	  [even odd]
	  proc{$ In Out}
	     Res in
	     Res = In.a*In.b
	     case Res mod 2
	     of 0 then {Send Out.even Res}
	     else {Send Out.odd Res}
	     end
	  end }


%Bind componenet together
{Component.bind Filter.outPorts.even Even.inPorts.input}
{Component.bind Filter.outPorts.odd Odd.inPorts.input}

{Send Filter.inPorts.a 7}
{Send Filter.inPorts.b 2}