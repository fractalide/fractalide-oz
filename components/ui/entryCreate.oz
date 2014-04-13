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
		   procedures(proc {$ Out Comp}
				 {Out.ui_out fun{$ Out}
						entry(action: proc{$} {Out modify} end
						     )
					     end
				 }
			      end)
		   )
      }
   end
end
     