functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat Name}
      {Comp.new comp(name:Name type:concat
		     inArrayPorts(input(proc {$ Buffers Out Comp}
					    %{Out.out {FoldL IP fun{$ Acc X} Acc+X end 0}}
					    Tab = {Map Buffers fun {$ El} {El.get} end}
					 in
					    {Out.out Tab}
					 end)
				 )
		     outPorts(out)
		    )
      }
   end
end