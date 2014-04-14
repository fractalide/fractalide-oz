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
		   inPorts(ui_in: proc {$ Buf Out Var State Options} UI in
				     UI = {Buf.get}
				     Var.uiin = {Record.adjoin UI panel}
				  end
			  )
		   inArrayPorts(panel: proc {$ Buffers Out Var State Options} NewUI in
					  NewUI = {List.toRecord panel {List.mapInd Buffers fun {$ I Buf} I#{Buf.get} end}}
					  Var.panel = {Record.adjoin NewUI panel}
				       end)
		   procedures(proc {$ Out Var State Options}
				 {Out.ui_out fun {$ _}
						{Record.adjoin Var.panel Var.uiin}
					     end
				 }
			      end
			     )
		   var(uiin panel)
		   )
      }
   end
end
     