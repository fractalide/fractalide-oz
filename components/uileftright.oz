functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat Name}
      {Comp.new comp(name:Name type:uitopdown
		     inArrayPorts(input: proc {$ Buffers Out Nvar State Options}
					    Tab = {FoldL Buffers
						   fun {$ Acc El}
						      {Record.adjoinAt Acc {Width Acc}+1 {El.get}}
						   end
						   lr()
						  }
					 in
					    {Out.out Tab}
					 end
				 )
		     outPorts(out)
		    )
      }
   end
end