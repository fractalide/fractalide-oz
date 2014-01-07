functor
import
   Comp at '../lib/component.ozf'
   OS
export
   new: CompNewArgs
define
   fun {CompNewArgs}
      {Comp.new comp(
		   inPorts(arrayPort(name:input
				     procedure: proc{$ IP Out NVar State Options}
				     		   {Delay 1000}
				     		   {OS.kill {OS.getPID} 'SIGINT'}
						end))
		   )}
   end
end