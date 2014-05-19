functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/uiObject/create'
		   inPorts('in')
		   outPorts(image name photo)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				{Out.image create(IP.x IP.y)}
				{Out.image lower}
				
				{Out.name create(IP.x IP.y text:{Atom.toString IP.name})}
				{Out.photo photo(file:"./components/editor/images/circle.gif")}
			     end)
		   )
      }
   end
end