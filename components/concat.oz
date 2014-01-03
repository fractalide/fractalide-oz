functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat}
      {Comp.new comp(inPorts(arrayPort(name: input
				  procedure:   proc {$ IP Out Nvar State Options}
						   %{Out.out {FoldL IP fun{$ Acc X} Acc+X end 0}}
						   {Out.out IP}
					       end
				 )
			    )
		     outPorts(out:port)
		    )
      }
   end
end