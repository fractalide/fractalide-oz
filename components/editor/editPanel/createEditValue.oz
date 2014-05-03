functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/createEditValue'
		   inPorts(
		      input(proc{$ In Out Comp} IP  in
			       IP = {In.get}
			       {Out.label opt(label:IP.1)}
			       {Out.value create(init:IP.2)}
			    end)
		      )
		   outPorts(label value)
		   )
      }
   end
end