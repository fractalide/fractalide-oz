functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name}
      {Comp.new component(
		   name: Name type:'graph/bind'
		   inPorts(outComp(proc{$ In Out Comp} 
				      Comp.var.outComp = {In.get}.1
				   end)
			   inComp(proc{$ In Out Comp}
				     Comp.var.inComp = {In.get}.1
				  end)
			   ports(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    Comp.var.ports = IP
				 end)
			  )
		   procedures(proc {$ Out Comp}
				 for P in Comp.var.ports do O I in
				    O#I = P
				    {Comp.var.outComp bind(O Comp.var.inComp I)}
				 end
				 {Out.outComp Comp.var.outComp}
				 {Out.inComp Comp.var.inComp}
			      end)
		   outPorts(outComp inComp)
		   var(outComp inComp ports)
		   
		   )
      }
   end
end
     