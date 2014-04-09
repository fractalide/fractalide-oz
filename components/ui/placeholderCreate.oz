functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:placeholderCreate
		   outPorts(ui_out set)
		   inArrayPorts(ui_in: proc {$ Buffers Out NVar State Options} NewUI in
					  NewUI = {Map Buffers fun {$ Buf} {Buf.get} end}
					  {Out.ui_out fun{$ _}
							 placeholder
						      end
					  }
					  for UI in NewUI do
					     {Out.set set(UI)}
					  end
				       end)
		   )
      }
   end
end
     