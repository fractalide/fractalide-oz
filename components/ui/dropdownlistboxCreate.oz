functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:dropdownlistboxCreate
		   outPorts(ui_out)
		   inPorts(list: proc {$ In Out Var State Options}
				    Var.list = l(init:{In.get})
				 end
			   ui_in: proc {$ Buf Out Var State Options} 
				     Var.options = {Buf.get}
				  end)
		   procedures(proc {$ Out Var State Options} D FuturOut in
				D = dropdownlistbox(action: proc{$} {FuturOut get(firstselection output:select)} end
						   )
				{Out.ui_out fun{$ FO}
					       FuturOut = FO
					       {Record.adjoin {Record.adjoin Var.options Var.list} D}
					    end
				}
			     end
			    )
		   var(list options)
		   )
      }
   end
end
     