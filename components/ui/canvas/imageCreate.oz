functor
import
   Comp at '../../../lib/component.ozf'
export
   new: New
define
   fun {RecordIncInd Rec} NRec in
      NRec = {Record.make create
	      {List.map {Record.toListInd Rec}
	       fun {$ Ind#_} if {Int.is Ind} then Ind+1 else Ind end end}
	     }
      for I in {Arity NRec} do
	 if {Int.is I} then
	    NRec.I = Rec.(I-1)
	 else
	    NRec.I = Rec.I
	 end
      end
      NRec
   end
   fun {New Name} 
      {Comp.new component(
		   name: Name type:imageCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc{$ In Out Comp} UI in
				     UI = {In.get}
				     Comp.var.rec = {Record.adjoin {RecordIncInd UI} create(image image:_)}
				  end)
			   image(proc{$ In Out Comp} Im in
				      Im = {In.get}
				      (Comp.var.rec).image = Im
				   end)
			  )
		   procedures(proc {$ Out Comp}
				 {Wait Comp.var.rec.image}
				 {Out.ui_out fun{$ _}
						Comp.var.rec
					     end
				 }
			      end)
		   var(rec)
		   )
      }
   end
end
          