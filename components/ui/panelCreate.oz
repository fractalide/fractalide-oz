functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:panelCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc{$ In Out Comp} UI in
				     UI = {In.get}
				     Comp.var.uiin = {Record.adjoin UI panel}
				  end)
			  )
		   inArrayPorts(panel(proc{$ Ins Out Comp} NewUI in
					  NewUI = {List.toRecord panel {List.mapInd Ins fun {$ I In} I#{In.get} end}}
					  Comp.var.panel = {Record.adjoin NewUI panel}
				      end)
				)
		   procedures(proc {$ Out Comp}
				 {Out.ui_out fun {$ _}
						{Record.adjoin Comp.var.panel Comp.var.uiin}
					     end
				 }
			      end
			     )
		   var(uiin panel)
		   )
      }
   end
end
     