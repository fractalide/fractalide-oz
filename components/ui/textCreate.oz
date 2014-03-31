functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:textCreate
		   outPorts(eo opt uo)
		   procedures(proc {$ Out NVar State Options} H in
				 {Out.uo text(handle:H)}
				 {Wait H}
				 {Out.opt opt(handle:H)}
			      end)
		   )
      }
   end
end
     