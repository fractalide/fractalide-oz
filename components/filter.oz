functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:filter
		     inPorts(input)
		     outPorts(output)
		     options(p:_)
		     procedure(proc{$ Ins Out Comp} IP in
				  IP = {Ins.input.get}
				  if {Comp.options.p IP} then
				     {Out.output IP}
				  end
			       end)
		    )}
   end
end