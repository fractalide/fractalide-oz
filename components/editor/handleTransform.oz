functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/test'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       {Out.output opt(canvas:IP.1)}
			    end)
		      )
		   outPorts(output)
		   )
      }
   end
end