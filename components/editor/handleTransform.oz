functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/test'
		   inPorts(input)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} IP in
			       IP = {Ins.input.get}
			       {Out.output opt(canvas:IP.1)}
			    end)
		   )
      }
   end
end