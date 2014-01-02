functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand}
      {Comp.new comp(inPorts(
			port(name: x
			     procedure: proc{$ IP Out NVar State Options}
					   NVar.x = IP
					end
			    )
			port(name: y
			     procedure: proc{$ IP Out NVar State Options}
					   NVar.y = IP
					end
			    )
			)
		     outPorts(out:port)
		     procedures(proc {$ Out NVar State Options}
				   case NVar.x#NVar.y
				   of 1#1 then {Out.out 0}
				   else {Out.out 1}
				   end
				end)
		     var(x y)
		    )
       
      }
   end
end