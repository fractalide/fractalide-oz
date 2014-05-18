functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/component/create'
		   inPorts('in')
		   outPorts(comp uiObj)
		   procedure(proc{$ Ins Out Comp} IP X Y Name in
				IP = {Ins.'in'.get}
				X = IP.x
				Y = IP.y
				Name = {Atom.toString IP.name}
				{Out.uiObj create(x:X y:Y name:IP.name path:"./components/editor/images/circle.gif")}
				{Out.comp create(name:Name)}
			     end)
		   )
      }
   end
end