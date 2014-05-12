functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/addLabel'
		   inPorts(input)
		   options(label:_)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} IP in
			       IP = {Ins.input.get}
			       {Out.output change(label:Comp.options.label value:IP.1)}
			    end)
		   )
      }
   end
end