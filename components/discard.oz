functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:discard
		     inPorts(input(proc{$ In Out Comp}
				      _ = {In.get}
				   end))
		    )
      }
   end
end