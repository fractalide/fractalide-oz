functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:entryCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc {$ In Out Comp} NewUI D FuturOut in
				     NewUI = {In.get}
				     D = entry(action: proc{$} {FuturOut get(firstselection output:select)} end
					      )
				     {Out.ui_out fun{$ FO}
						    FuturOut = FO
						    {Record.adjoin {Record.adjoin D NewUI} entry}
						 end
				     }
				  end)
			  )
		   )
      }
   end
end
     