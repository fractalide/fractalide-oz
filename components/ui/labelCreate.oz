functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:labelCreate
		   outPorts(uo)
		   procedures(proc {$ Out NVar State Options}
				 {Out.uo fun{$ _}
					    label
					 end
				 }
			      end)
		   )
      }
   end
end
     