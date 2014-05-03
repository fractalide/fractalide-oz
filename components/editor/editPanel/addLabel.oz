functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/addLabel'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       {Out.output change(label:Comp.options.label value:IP.1)}
			    end)
		      )
		   options(label:_)
		   outPorts(output)
		   )
      }
   end
end