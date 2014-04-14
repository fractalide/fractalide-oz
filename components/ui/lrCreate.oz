functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:lrCreate
		   outPorts(out)
		   inArrayPorts(input: proc {$ Buffers Out Var State Options} Rec in
					  Rec = {List.toRecord td
						 {List.mapInd Buffers
						  fun {$ Ind El} E in
						     E = {El.get}
						     Ind#E
						  end
						 }
						}
					  Var.list = Rec
				       end
			       )
		   inPorts(ui_in: proc {$ In Out Var State Options}
				     Var.rec = {Record.adjoin {In.get} lr}
				  end)
		   procedures(proc {$ Out Var State Options}
				 {Out.out fun{$ _}
					     {Record.adjoin Var.list Var.rec}
					  end}
			      end
			     )
		   var(list rec)
		   )
      }
   end
end
     