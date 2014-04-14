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
		   name: Name type:bitmapCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc{$ In Out Comp} UI in
				    UI = {In.get}
				    {Out.ui_out fun{$ _}
						   {Record.adjoin {RecordIncInd UI} create(bitmap)}
						end
				    }
				 end)
			  )
		   )
      }
   end
end
          