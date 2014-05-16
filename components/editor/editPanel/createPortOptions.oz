functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/createPortOptions'
		   inPorts('in')
		   outPorts(grid to 'from')
		   procedure(proc{$ Ins Out Comp} IP  in
				IP = {Ins.'in'.get}
				{Out.grid create(bg:white)}
				{Out.to create(init:IP.to)}
				{Out.'from' create(init:IP.'from')}
			     end)
		   )
      }
   end
end