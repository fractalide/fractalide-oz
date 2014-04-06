functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:canvasCreate
		   outPorts(ui_out)
		   procedures(proc {$ Out NVar State Options}
				 {Out.ui_out fun{$ _}
					    canvas
					 end
				 }
			      end)
		   )
      }
   end
end
     