functor
import
   Comp at '../../../lib/component.ozf'
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
			    )
		     procedures(proc{$ Out Comp} C M in
				   M = Comp.var.move
				   case {Label M}
				   of moveBegin then
				      {Out.output setCoords(M.x M.y Comp.state.3 Comp.state.4)}
				      Comp.state.1 := M.x
				      Comp.state.2 := M.y
				   [] moveEnd then
				      {Out.output setCoords(Comp.state.1 Comp.state.2 M.x M.y)}
				      Comp.state.3 := M.x
				      Comp.state.4 := M.y
				   else
				      skip
				   end
				end)
		     outPorts(output)
		     var(move)
		     state(1:0 2:0 3:0 4:0)
		    )
      }
   end
end