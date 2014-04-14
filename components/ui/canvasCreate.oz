functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:canvasCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc {$ In Out Comp} NewUI FuturOut in
				     NewUI = {In.get}
				     {Out.ui_out fun{$ FO}
						    FuturOut = FO
						    {Record.adjoin NewUI canvas}
						 end
				     }
				 end)
			   )
		   )
      }
   end
end
     