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
		   inArrayPorts(ui_in: proc {$ Buffers Out NVar State Options} NewUI D FuturOut in
					  NewUI = {List.toRecord panel {List.mapInd Buffers fun {$ I Buf} I#{Buf.get} end}}
				     D = panel()
				     {Out.ui_out fun{$ FO}
						    FuturOut = FO
						    {Record.adjoin {Record.adjoin D NewUI} panel}
						 end
				     }
				  end)
		   )
      }
   end
end
     