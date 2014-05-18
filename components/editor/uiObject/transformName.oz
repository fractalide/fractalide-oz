functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/uiObject/transformName'
		   inPorts('in')
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				{Out.out set(text:IP.1)}
			     end)
		   )
      }
   end
end