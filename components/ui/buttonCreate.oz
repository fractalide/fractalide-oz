functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:buttonCreate
		   outPorts(eo opt uo)
		   procedures(proc {$ Out NVar State Options} H in
				 {Out.uo button(action: proc{$} {Out.eo button_clicked} end
						text:default
						handle:H
					       )
				 }
				 {Wait H}
				 {Out.opt opt(handle:H)}
			      end)
		   )
      }
   end
end
     