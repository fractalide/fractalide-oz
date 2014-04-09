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
		   inArrayPorts(ui_in: proc {$ Buffers Out NVar State Options} NewUI D FuturOut in
				     NewUI = {List.toRecord grid {List.mapInd Buffers fun {$ I Buf} I#{Buf.get} end}}
				     D = grid()
				     {Out.ui_out fun{$ FO}
						    FuturOut = FO
						    {Record.adjoin {Record.adjoin D NewUI} grid}
						 end
				     }
				  end)
		   )
      }
   end
end
     