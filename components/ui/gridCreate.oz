functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:gridCreate
		   outPorts(ui_out)
		   inArrayPorts(grid(proc {$ Ins Out Comp} NewUI in
					NewUI = {List.toRecord grid {List.mapInd Ins fun {$ I In} I#{In.get} end}}
					Comp.var.grid = NewUI
				     end)
			       )
		   inPorts(ui_in(proc {$ In Out Comp} UI in
				    UI = {In.get}
				    Comp.var.uiin = {Record.adjoin UI grid}
				 end)
			  )
		   procedures(proc {$ Out Comp}
				 {Out.ui_out fun {$ _}
						{Record.adjoin Comp.var.grid Comp.var.uiin}
					     end
				 }
			      end
			     )
		   var(uiin grid)
		   )
      }
   end
end
     