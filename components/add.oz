functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:add
		     inArrayPorts(input: proc{$ IP Out NVar State Options}
					    {Out.output {FoldL IP
							 fun{$ Acc X} E I in
							    E = {X.get}.1
							    if {String.isInt E} then
							       I = {String.toInt E}
							    else
							       I = 0
							    end
							    Acc+I
							 end
							 0}}
					 end)
		     outPorts(output)
		   )}
   end
end