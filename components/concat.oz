functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat}
      {Comp.new comp(inArrayPorts(input: proc {$ Buffers Out Nvar State Options}
					    %{Out.out {FoldL IP fun{$ Acc X} Acc+X end 0}}
					    Tab = {Map Buffers fun {$ El} {El.get} end}
					 in
					    {Out.out Tab}
					 end
				 )
		     outPorts(out)
		    )
      }
   end
end