functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:filter
		   inPorts(input: proc{$ IP Out NVar State Options}
					 if {Options.p IP} then
					    {Out.output IP}
					 end
				      end)
		     outPorts(output)
		    )}
   end
end