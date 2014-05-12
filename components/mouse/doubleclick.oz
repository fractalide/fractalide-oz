functor
import
   Comp at '../../lib/component.ozf'
   
   % For mozart2
   %Milli at 'x-oz://boot/Time'
   % For mozart1.4
   OS
   
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:doubleclick
		     inPorts(input)
		     outPorts(output)
		     procedure(proc{$ Ins Out Comp}
				      IP = {Ins.input.get}
				   in
				      case {Label IP}
				      of 'ButtonPress' andthen IP.button == 1 then T in
					 % For Mozart2
					 %T = {Milli.getReferenceTime}
					 % For Mozart1.4
					 T = {OS.time}

					 % For Mozart2 : < 500
					 % For Mozart1.4 : < 1
					 if Comp.state.last > 0 andthen T-Comp.state.last < 1 then {Out.output {Record.adjoin IP doubleclick}} end 
					 Comp.state.last := T
				      else skip
				      end
				   end)
		     state(last:~1)
		    )
      }
   end
end