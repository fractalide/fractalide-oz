functor
import
   Comp at '../lib/component.ozf'
export
   new: New
define
   fun {New Name} Generator in
      Generator = {Comp.new component(
			       name: Name type:generator
			       inPorts(input)
			       outPorts(output)
			       procedure(proc{$ Ins Out Comp} IP in
					    IP = {Ins.input.get}
					    {Out.output IP+1}
					    {Delay Comp.options.delay}
					 end)
			       options(delay:1000)
			       )
		  }
      {Generator bind(output Generator input)}
      Generator
   end
end
     