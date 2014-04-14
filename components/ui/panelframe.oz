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
		   inPorts(panel(proc{$ In Out Comp}
				     Comp.var.panel = widget({In.get})
				  end)
			   title(proc{$ In Out Comp}
				     Comp.var.title = td(title:{In.get})
				  end)
			  )
		   procedures(proc {$ Out Comp}
				 {Out.ui_out {Record.adjoin Comp.var.panel Comp.var.title}}
			      end
			     )
		   var(panel title)
		   )
      }
   end
end
     