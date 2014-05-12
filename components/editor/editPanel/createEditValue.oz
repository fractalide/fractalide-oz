functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/createEditValue'
		   inPorts(input)
		   outPorts(label value)
		   procedure(proc{$ Ins Out Comp} IP  in
			       IP = {Ins.input.get}.1
			       {Out.label create(label:IP.1)}
			       {Out.value create(init:IP.2)}
			    end)
		   )
      }
   end
end