functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat}
      {Comp.new comp(inPorts(arrayPort(name: input
				  procedure:   proc {$ Buffers Out Nvar State Options}
						   %{Out.out {FoldL IP fun{$ Acc X} Acc+X end 0}}
						  Tab = {Map Buffers fun {$ El} {El.get} end}
					       in
						  {Out.out Tab}
					       end
				 )
			    )
		     outPorts(out:port)
		    )
      }
   end
end