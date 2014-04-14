functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:filter
		     inPorts(input(proc{$ IP Out Comp}
				      if {Comp.options.p IP} then
					 {Out.output IP}
				      end
				   end)
			    )
		     outPorts(output)
		     options(p:_)
		    )}
   end
end