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
		   inArrayPorts(input(proc{$ Ins Out Comp} Rec in
					  Rec = {List.toRecord td
						 {List.mapInd Ins
						  fun {$ Ind In} E in
						     E = {In.get}
						     Ind#E
						  end
						 }
						}
					  Comp.var.list = Rec
				       end)
			       )
		   inPorts(ui_in(proc{$ In Out Comp}
				     Comp.var.rec = {Record.adjoin {In.get} lr}
				  end)
			  )
		   procedures(proc {$ Out Comp}
				 {Out.out fun{$ _}
					     {Record.adjoin Comp.var.list Comp.var.rec}
					  end}
			      end
			     )
		   var(list rec)
		   )
      }
   end
end
     