functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:"editor/component/leftClick"
		     inPorts(input coord ep name)
		     procedure(proc{$ Ins Out Comp} IPInput Input IPCoord Coord Ep Name in
				  IPInput = {Ins.input.get}
				  Input = if {Label IPInput} == 'ButtonRelease' andthen IPInput.button == 1 then true else false end
				  IPCoord = {Ins.coord.get}.1
				  Coord = coord(IPCoord.1 IPCoord.2.1 IPCoord.2.2.1 IPCoord.2.2.2.1)
				  Ep = {Ins.ep.get}.1
				  Name = {VirtualString.toAtom {Ins.name.get}.text}
				  if Input then X1 X2 Y in
				     X1 = Coord.1
				     X2 = Coord.3
				     Y = Coord.2 + (Coord.4-Coord.2)/2.0
				     {Out.output createLink(x1:X1 x2:X2 y:Y entryPoint:Ep name:Name)}
				  end
			       end)
		     outPorts(output)
		    )
      }
   end
end