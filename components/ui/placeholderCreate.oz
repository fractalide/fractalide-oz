functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:placeholderCreate
		   outPorts(ui_out)
		   procedures(proc {$ Out NVar State Options}
				 {Out.ui_out fun{$ _}
					    placeholder
					 end
				 }
			      end)
		   )
      }
   end
end
     