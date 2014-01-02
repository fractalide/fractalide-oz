functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs}
      {Comp.new comp(
		   inPorts(arrayPort(name:input
				     procedure: proc{$ IP Out NVar State Options}
						   {Out.output {FoldL IP fun{$ Acc X} Acc+X end 0}}
						end))
		   outPorts(output:port)
		   )}
   end
end