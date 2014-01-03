functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand}
      {Comp.new comp(inPorts(
			port(name: a
			     procedure: proc{$ IP Out NVar State Options}
					   NVar.a = IP
					end
			    )
			port(name: b
			     procedure: proc{$ IP Out NVar State Options}
					   NVar.b = IP
					end
			    )
			)
		     outPorts(out:port)
		     procedures(proc {$ Out NVar State Options}
				   case NVar.a#NVar.b
				   of 1#1 then {Out.out 0}
				   else {Out.out 1}
				   end
				end)
		     var(a b)
		    )
      }
   end
end