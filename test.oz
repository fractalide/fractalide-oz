declare
[C] = {Module.link ["./lib/component_old.ozf"]}
[G] = {Module.link ["./lib/graph.ozf"]}
Filter = {G.new filter}
{G.addInPort Filter input}
{G.addOutPort Filter even}
{G.addOutPort Filter odd}
Even = {G.new even}
{G.addInPort Even input}
Odd = {G.new odd}
{G.addInPort Odd input}
{G.bind Filter even Even input}
{G.bind Filter odd Odd input}
CompFilter = {C.new [input] [even odd]
	      proc{$ In Out}
		 if In.input mod 2 == 0 then
		    {Send Out.even In.input}
		 else
		    {Send Out.odd In.input}
		 end
	      end
	     }
CompOdd = {C.new [input] nil
	   proc {$ In Out}
	      {Browse In.input#' is a odd number'}
	   end
	  }
CompEven = {C.new [input] nil
	    proc {$ In Out}
	       {Browse In.input#' is an even number'}
	    end
	   }
{G.exchange Even CompEven}
{G.exchange Odd CompOdd}
{G.exchange Filter CompFilter}


{Send CompFilter.inPorts.input 2}
{Send CompFilter.inPorts.input 23}

declare
NewCompFilter = {C.addInPort CompFilter input2}
NewFilter = {C.changeProc NewCompFilter
	     proc {$ In Out}
		Res in
		Res = In.input * In.input2
		if Res mod 2 == 0 then
		   {Send Out.even Res}
		else
		   {Send Out.odd Res}
		end
	     end
	    }
{G.exchange Filter NewFilter}

{Send NewFilter.inPorts.input 3}
{Send NewFilter.inPorts.input2 23}
