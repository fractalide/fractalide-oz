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
		   inPorts(ui_in: proc {$ Buf Out NVar State Options} UI in
				     UI = {Buf.get}
				     NVar.rec = {Record.adjoin {RecordIncInd UI} create(image image:_)}
				  end
			   image : proc {$ Buf Out NVar State Options} Im in
				      Im = {Buf.get}
				      (NVar.rec).image = Im
				   end
			  )
		   procedures(proc {$ Out NVar State Options}
				 {Wait NVar.rec.image}
				 {Out.ui_out fun{$ _}
						NVar.rec
					     end
				 }
			      end)
		   var(rec)
		   )
      }
   end
end
          