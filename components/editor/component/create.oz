functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} Radius in
      Radius = 50.0
      {Comp.new comp(
		   name:Name type:'components/editor/component/create'
		   inPorts('in')
		   outPorts(bg border name comp)
		   procedure(proc{$ Ins Out Comp} IP X Y in
				IP = {Ins.'in'.get}
				X = IP.x
				Y = IP.y
				{Out.bg create(X-Radius+5.0 Y-Radius+5.0 X+Radius-5.0 Y+Radius-5.0 width:0 fill:white)}
				{Out.bg lower}
				{Out.border create(X-Radius Y-Radius X+Radius Y+Radius width:5)}
				{Out.name create(X Y text:{Atom.toString IP.name})}
				{Out.comp create(name:{Atom.toString IP.name})}
			     end)
		   )
      }
   end
end