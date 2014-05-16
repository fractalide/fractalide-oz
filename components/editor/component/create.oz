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
		   outPorts(name comp image canvas)
		   procedure(proc{$ Ins Out Comp} IP X Y in
				IP = {Ins.'in'.get}
				X = IP.x
				Y = IP.y
				{Out.image create(X Y)}
				{Out.image lower}
			
				{Out.name create(X Y text:{Atom.toString IP.name})}
				{Out.comp create(name:{Atom.toString IP.name})}
				{Out.canvas opt(canvas:IP.canvas)}
			     end)
		   )
      }
   end
end