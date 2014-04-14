functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:scrollframeCreate
		   outPorts(ui_out)
		   inPorts(ui_in: proc {$ Buf Out NVar State Options} NewUI in
				     NewUI = {Buf.get}
				     NVar.rec = {Record.adjoin NewUI scrollframe(1:_)}
				  end
			   frame: proc{$ Buf Out NVar State Options} Frame in
				     Frame = {Buf.get}
				     NVar.rec.1 = Frame
				  end
			  )
		   procedures(proc{$ Out NVar State Options}
				 {Wait NVar.rec.1}
				 {Out.ui_out fun{$ _} NVar.rec end}
			      end
			     )
		   var(rec)
		   )
      }
   end
end
     