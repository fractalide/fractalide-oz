functor
import
   Comp at '../lib/component.ozf'
export
   new: New
define
   fun {New Name} Generator in
      Generator = {Comp.new component(
			       name: Name type:generator
			       inPorts(input(proc{$ In Out Comp} IP in
						IP = {In.get}
						{Out.output IP+1}
						{Delay Comp.options.delay}
					     end)
				       )
			       outPorts(output)
			       options(delay:1000)
			       )
		  }
      {Generator bind(output Generator input)}
      Generator
   end
end
     