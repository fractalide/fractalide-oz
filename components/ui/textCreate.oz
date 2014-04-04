functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:buttonCreate
		   outPorts(ui_out)
		   procedures(proc {$ Out NVar State Options}
				 {Out.ui_out fun{$ _}
					    text
					 end
				 }
			      end)
		   )
      }
   end
end
     