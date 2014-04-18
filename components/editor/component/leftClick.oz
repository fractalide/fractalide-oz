functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:"editor/component/leftClick"
		     inPorts(input(proc{$ In Out Comp}
				      IP = {In.get}
				   in
				      if {Label IP} == 'ButtonRelease' andthen IP.button == 1 then
					 Comp.var.input = true
				      else
					 Comp.var.input = false
				      end
				   end)
			     coord(proc{$ In Out Comp} IP in
				      IP = {In.get}.1
				      Comp.var.coord = coord(IP.1 IP.2.1 IP.2.2.1 IP.2.2.2.1)
				   end)
			     ep(proc{$ In Out Comp}
				   Comp.var.ep = {In.get}.1
				end)
			    )
		     procedures(proc{$ Out Comp}
				   if Comp.var.input then C X1 X2 Y in
				      C = Comp.var.coord
				      X1 = C.1
				      X2 = C.3
				      Y = C.2 + (C.4-C.2)/2.0
				      {Out.output createLink(x1:X1 x2:X2 y:Y entryPoint:Comp.var.ep)}
				   end
				end)
		     outPorts(output)
		     var(input coord ep)
		    )
      }
   end
end