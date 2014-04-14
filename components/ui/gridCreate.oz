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
		   inArrayPorts(grid: proc {$ Buffers Out NVar State Options} NewUI in
					  NewUI = {List.toRecord grid {List.mapInd Buffers fun {$ I Buf} I#{Buf.get} end}}
					  NVar.grid = NewUI
				       end
			       )
		   inPorts(ui_in: proc {$ Buf Out NVar State Options} UI in
				     UI = {Buf.get}
				     NVar.uiin = {Record.adjoin UI grid}
				  end
			  )
		   procedures(proc {$ Out NVar State Options}
				 {Out.ui_out fun {$ _}
						{Record.adjoin NVar.grid NVar.uiin}
					     end
				 }
			      end
			     )
		   var(uiin grid)
		   )
      }
   end
end
     