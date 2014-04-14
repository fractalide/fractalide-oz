functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:panelframe
		   outPorts(ui_out)
		   inPorts(panel: proc {$ In Out Var State Options}
				     Var.panel = widget({In.get})
				  end
			   title: proc {$ In Out Var State Options}
				     Var.title = td(title:{In.get})
				  end
			  )
		   procedures(proc {$ Out Var State Options}
				 {Out.ui_out {Record.adjoin Var.panel Var.title}}
			      end
			     )
		   var(panel title)
		   )
      }
   end
end
     