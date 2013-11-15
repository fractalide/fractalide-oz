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

{Send NFilter.inPorts.i1 2}
{Send NFilter.inPorts.i2 21}
