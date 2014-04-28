functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name}
      {Comp.new component(
		   name: Name type:'graph/bind'
		   inPorts(comp(proc{$ In Out Comp}
				   Comp.var.theComp = {In.get}
				end)
			   message(proc{$ In Out Comp}
				      Comp.var.msg = {In.get}
				   end)
			   port(proc{$ In Out Comp}
				   Comp.var.port = {In.get}
				end)
			  )
		   procedures(proc {$ Out Comp} Ack in
				 {Comp.var.theComp send(Comp.var.port Comp.var.msg Ack)}
				 {Wait Ack}
			      end)
		   var(theComp msg port)
		   
		   )
      }
   end
end
     