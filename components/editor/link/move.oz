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
			     coord(proc{$ In Out Comp} IP R in
				      IP = {In.get}.1
				      R = coord(IP.1 IP.2.1 IP.2.2.1 IP.2.2.2.1)
				      Comp.var.coord = {Record.map R
							fun {$ El}
							   {Float.toInt El}
							end
							}
				   end)
			    )
		     procedures(proc{$ Out Comp} C M in
				   C = Comp.var.coord
				   M = Comp.var.move
				   case {Label M}
				   of moveBegin then
				      {Out.output setCoords(M.x M.y C.3 C.4)} 
				   [] moveEnd then
				      {Out.output setCoords(C.1 C.2 M.x M.y)}
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