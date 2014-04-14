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
		   inArrayPorts(place: proc {$ Buffers Out Var State Options}
					  Var.widgets = {Map Buffers fun {$ Buf} {Buf.get} end}

				       end)
		   inPorts(ui_in: proc {$ In Out Var State Options}
				     Var.uiin = {In.get}
				  end
			  )
		   procedures(proc {$ Out Var State Options}
				 {Out.ui_out fun{$ _}
						{Record.adjoin Var.uiin placeholder}
					     end
				 }
				 for UI in Var.widgets do
				    {Out.set set(UI)}
				 end
			      end
			     )
		   var(widgets uiin)
		   )
      }
   end
end
     