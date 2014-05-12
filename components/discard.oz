functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:discard
		     inPorts(input)
		     procedure(proc{$ Ins Out Comp}
				  _ = {Ins.input.get}
			       end)
		    )
      }
   end
end