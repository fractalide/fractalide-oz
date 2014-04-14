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
		   inPorts(ui_in(proc{$ In Out Comp} NewUI in
				     NewUI = {In.get}
				     Comp.var.rec = {Record.adjoin NewUI scrollframe(1:_)}
				  end)
			   frame(proc{$ In Out Comp} Frame in
				     Frame = {In.get}
				     Comp.var.rec.1 = Frame
				  end)
			  )
		   procedures(proc{$ Out Comp}
				 {Wait Comp.var.rec.1}
				 {Out.ui_out fun{$ _} Comp.var.rec end}
			      end
			     )
		   var(rec)
		   )
      }
   end
end
     