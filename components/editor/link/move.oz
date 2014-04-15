functor
import
   Comp at '../../../lib/component.ozf'
   System
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:move
		     inPorts(move(proc{$ In Out Comp}
				      IP = {In.get}
				   in
				      Comp.var.move = IP
				   end)
			     coord(proc{$ In Out Comp}
				      Comp.var.coord = {In.get}
				   end)
			    )
		     procedures(proc{$ Out Comp} C M in
				   C = Comp.var.coord
				   M = Comp.var.move
				   {System.show c#C}
				   {System.show m#M}
				   case {Label M}
				   of moveBegin then
				      {Out.output setCoords(C.1+M.x C.2+M.y C.3 C.4)} 
				   [] moveEnd then
				      {Out.output setCoords(C.1 C.2 C.3+M.x C.4+M.y)}
				   else
				      skip
				   end
				end)
		     outPorts(output)
		     var(coord move)
		    )
      }
   end
end