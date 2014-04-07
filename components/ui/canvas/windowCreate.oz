functor
import
   Comp at '../../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:windowCreate
		   outPorts(ui_out)
		   inPorts(ui_in: proc {$ Buf Out NVar State Options} IP in
				     IP = {Buf.get}
				     {Out.ui_out fun{$ _}
						    create(window 0 0 window:IP)
						 end
				     }
				  end)
		   )
      }
   end
end
          