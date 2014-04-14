functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:placeholderCreate
		   outPorts(ui_out set)
		   inArrayPorts(place(proc{$ Ins Out Comp}
					  Comp.var.widgets = {Map Ins fun {$ In} {In.get} end}

				       end)
			       )
		   inPorts(ui_in(proc{$ In Out Comp}
				     Comp.var.uiin = {In.get}
				  end)
			  )
		   procedures(proc {$ Out Comp}
				 {Out.ui_out fun{$ _}
						{Record.adjoin Comp.var.uiin placeholder}
					     end
				 }
				 for UI in Comp.var.widgets do
				    {Out.set set(UI)}
				 end
			      end
			     )
		   var(widgets uiin)
		   )
      }
   end
end
     