functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:add
		     inArrayPorts(input(proc{$ Ins Out Component}
					    {Out.output {FoldL Ins
							 fun{$ Acc In}
							    Acc+{In.get}
							 end
							 0}}
					end)
				  )
		     outPorts(output)
		   )}
   end
end