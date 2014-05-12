functor
import
   Comp at '../lib/component.ozf'
export
   new: NewSplitter
define
   fun {NewSplitter Name}
      {Comp.new comp(name:Name type:splitter
		     inPorts(input
			    )
		     outArrayPorts(out)
		     procedure(proc {$ Ins Out Comp}
				      {FoldL {Ins.input.get} fun {$ Acc IP} {Out.out.Acc IP} Acc+1 end 1 _}
				   end)
		    )
      }
   end
end