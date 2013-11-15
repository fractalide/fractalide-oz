declare
[C] = {Module.link ["./lib/component_old.ozf"]}
[G] = {Module.link ["./lib/graph.ozf"]}
Filter = {G.new filter}
{G.addInPort Filter input}
Odd = {G.new odd}
{G.addInPort Odd input}
Even = {G.new even}
{G.addInPort Even input}
{G.addOutPort Filter odd}
{G.addOutPort Filter even}
{G.bind Filter odd Odd input}
{G.bind Filter even Even input}
{G.changeProc Filter
 proc {$ In Out}
    if In.input mod 2 == 0 then
       {Send Out.even In.input}
    else
       {Send Out.odd In.input}
    end
 end
}
{G.changeProc Odd
 proc {$ In Out}
    {Browse In.input#' is odd'}
 end
}
{G.changeProc Even proc {$ In Out} {Browse In.input#' is even'} end}

{Send @(Filter.comp).inPorts.input 2}
{Send @(Filter.comp).inPorts.input 23}

declare
NFilter = {C.new [i1 i2] [even odd]
	   proc {$ In Out}
	      Res in
	      Res = In.i1*In.i2
	      if Res mod 2 == 0 then
		 {Send Out.even Res}
	      else
		 {Send Out.odd Res}
	      end
	   end}
{G.exchange Filter NFilter}
%Remap the port of the node, the UI will help a lot for that...
{G.removeInPort Filter input}
{G.addInPort Filter i1}
{G.addInPort Filter i2}

{Send NFilter.inPorts.i1 2}
{Send NFilter.inPorts.i1 3}
{Send NFilter.inPorts.i2 21}
{Send NFilter.inPorts.i2 21}

{G.removeInPort Filter i1}
{G.removeOutPort Filter odd}
{G.changeProc Filter
 proc {$ In Out}
    if In.i2 mod 2 == 0 then
       {Send Out.even In.i2}
    else
       {Send Out.even (In.i2)+1}
    end
 end
}

{Send @(Filter.comp).inPorts.i2 3}
{Send @(Filter.comp).inPorts.i2 2}
