functor
import
   Comp at '../lib/component.ozf'
export
   new: NewSeparator
define
   fun {NewSeparator}
      {Comp.new comp(inPorts(port(name: input
				  procedure: proc {$ IP Out NVar State Options}
						{Out.out IP}
					     end
				 )
			    )
		     outPorts(out)
		    )
      }
   end
end
   