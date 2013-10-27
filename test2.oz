{Browse begin}

declare [C]={Module.link ["lib/component.ozf"]}
% Even component
Even = {C.new even}
{Browse {C.name Even}}
{C.addInPort Even input}
{C.changeProc Even proc {$ In Out} {Browse In.input#' is an even number'} end}
% Odd componenet
Odd = {C.new odd}
{Browse {C.name Odd}}
{C.addInPort Odd input}
{C.changeProc Odd proc {$ In Out} {Browse In.input#' is an odd number'} end}
% Filter component
Filter = {C.new filter}
{C.addOutPort Filter even}
{C.addOutPort Filter odd}
%Bind component
{C.bind Filter.outPorts.even Even.inPorts.input}
{C.bind Filter.outPorts.odd Odd.inPorts.input}
% I want that Filter take an arg, and send it to even or odd belowing that the arg is an even or an odd number
{C.changeProc Filter proc {$ In Out}
			if In.input mod 2 == 0 then
			   {Send Out.even In.input}
			else
			   {Send Out.odd In.input}
			end
		     end}
{C.addInPort Filter input}



%test it
{Send Filter.inPorts.input 5}
{Send Filter.inPorts.input 6}

%Fine, but in fact, I want at port input a*x
{C.addInPort Filter a}
{C.addInPort Filter x}

{C.removeInPort Filter input}

{C.changeProc Filter proc {$ In Out}
			Res in
			Res = In.a * In.x
			if Res mod 2 == 0 then
			   {Send Out.even Res}
			else
			   {Send Out.odd Res}
			end
		     end}

{Send Filter.inPorts.a 3333}
{Send Filter.inPorts.x 762}


%Ok, now I want to know the result of a linear function where x = 5
{Send Filter.inPorts.x 5}
%But I forget a port a*x + b
{C.addInPort Filter b}
{C.changeProc Filter proc {$ In Out}
			Res in
			Res = In.a * In.x + In.b
			if Res mod 2 == 0 then
			   {Send Out.even Res}
			else
			   {Send Out.odd Res}
			end
		     end}

%Then, I send just a and b
{Send Filter.inPorts.a 2}
{Send Filter.inPorts.b 5}
