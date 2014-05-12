functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:add
		     inArrayPorts(input)
		     procedure(proc{$ Ins Out Component}
				  {Out.output {Record.foldL Ins.input
					       fun{$ Acc In}
						  Acc+{In.get}
					       end
					       0}}
			       end)
		     outPorts(output)
		   )}
   end
end