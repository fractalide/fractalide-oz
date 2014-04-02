functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:buttonCreate
		   outPorts(uo)
		   procedures(proc {$ Out NVar State Options}
				 {Out.uo fun{$ _}
					    text
					 end
				 }
			      end)
		   )
      }
   end
end
     