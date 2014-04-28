functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name}
      {Comp.new component(
		   name: Name type:'graph/start'
		   inPorts(input(proc{$ In Out Comp}
				    {{In.get} start}
				 end)
			  )
		   outPorts(output)
		   )
      }
   end
end
     