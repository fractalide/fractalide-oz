functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:recFeature1
		     inPorts(input(proc{$ In Out Comp}
				      IP = {In.get}
				   in
				      {Out.output IP.1}
				   end)
			    )
		     outPorts(output)
		    )
      }
   end
end