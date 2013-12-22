functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs}
      {Comp.new comp(
		   inPorts(port(name:input
				procedure: proc{$ IP Out NVar State Options}
					      if {Options.p IP} then
						 {Out.output IP}
					      end
					   end))
		   outPorts(output)
		   )}
   end
end