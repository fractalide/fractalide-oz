functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:tdCreate
		   outPorts(out)
		   inArrayPorts(input: proc {$ Buffers Out NVar State Options} Rec in
					  Rec = {List.toRecord td
						 {List.mapInd Buffers
						  fun {$ Ind El} E in
						     E = {El.get}
						     Ind#E
						  end
						 }
						}
					  Var.list = Rec
				       end)
		   inPorts(ui_in: proc {$ In Out Var State Options} in
				     Var.rc = {Record.adjoin {In.get} td}
				  end)
		   procedures(proc {$ Out Var State Options}
				 {Out.ui_out fun{$ _}
						{Record.adjoin Var.list Var.rc}
					     end}
			     )
		   )
      }
   end
end
     