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
		   name: Name type:windowCreate
		   outPorts(ui_out)
		   inPorts(ui_in(proc{$ In Out Comp} UI in
				    UI = {In.get}
				    Comp.var.rec = {Record.adjoin {RecordIncInd UI} create(window window:_)}
				    
				 end)
			   window(proc{$ In Out Comp}
				     (Comp.var.rec).window = {In.get}
				  end)
			  )
		   procedures(proc {$ Out Comp}
				 {Wait (Comp.var.rec).window}
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
          