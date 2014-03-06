functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name tpye:add
		     inArrayPorts(input: proc{$ IP Out NVar State Options}
					    {Out.output {FoldL IP fun{$ Acc X} Acc+X end 0}}
					 end)
		     outPorts(output)
		   )}
   end
end