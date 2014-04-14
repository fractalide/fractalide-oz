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
		   inPorts(list(proc {$ In Out Comp}
				    Comp.var.list = l(init:{In.get})
				 end)
			   ui_in(proc {$ In Out Comp} 
				     Comp.var.options = {In.get}
				  end)
			  )
		   procedures(proc {$ Out Comp} D FuturOut in
				D = dropdownlistbox(action: proc{$} {FuturOut get(firstselection output:select)} end
						   )
				{Out.ui_out fun{$ FO}
					       FuturOut = FO
					       {Record.adjoin {Record.adjoin Comp.var.options Comp.var.list} D}
					    end
				}
			     end
			    )
		   var(list options)
		   )
      }
   end
end
     