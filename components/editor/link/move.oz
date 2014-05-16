functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:"editor/link/move"
		     inPorts(moveBegin moveEnd)
		     outPorts(output fromPort toPort)
		     state(1:0.0 2:0.0 3:0.0 4:0.0)
		     procedure(proc{$ Ins Out Comp} 
				  if {Ins.moveBegin.size} > 0 then {MoveBegin Ins.moveBegin Out Comp} end
				  if {Ins.moveEnd.size} > 0 then {MoveEnd Ins.moveEnd Out Comp} end
			      end)
		    )
      }
   end
   proc{MoveBegin In Out Comp} IP in
      IP = {In.get}
      % The position are saved to avoid getCoords at each time
      case {Label IP}
      of move then 
	 Comp.state.1 := Comp.state.1 + {Int.toFloat IP.1}
	 Comp.state.2 := Comp.state.2 + {Int.toFloat IP.2}
      [] position then
	 Comp.state.1 := IP.x
	 Comp.state.2 := IP.y
      end
      {ShortLine Out Comp}
   end
   proc{MoveEnd In Out Comp} IP in
      IP = {In.get}
      % The position are saved to avoid getCoords at each time
      case {Label IP}
      of move then
	 Comp.state.3 := Comp.state.3 + {Int.toFloat IP.1}
	 Comp.state.4 := Comp.state.4 + {Int.toFloat IP.2}
	 {ShortLine Out Comp}
      [] position then
	 Comp.state.3 := IP.x
	 Comp.state.4 := IP.y
	 {ShortLine Out Comp}
      [] mousePosition then
	 {Out.output setCoords(Comp.state.1 Comp.state.2 IP.x IP.y)}
	 Comp.state.3 := IP.x
	 Comp.state.4 := IP.y
      end
   end
   proc {ShortLine Out Comp} R VX VY Dist NX NY NX2 NY2 in
      R = 50.0
      VX = Comp.state.3 - Comp.state.1
      VY = Comp.state.4 - Comp.state.2
      Dist = {Sqrt (VX*VX + VY*VY)}
      NX = R * (VX/Dist)
      NY = R * (VY/Dist)
      NX2 = R * ~(VX/Dist)
      NY2 = R * ~(VY/Dist)
      {Out.output setCoords(Comp.state.1+NX Comp.state.2+NY Comp.state.3+NX2 Comp.state.4+NY2)}
      {Out.fromPort setCoords(Comp.state.1+(2.0*NX) Comp.state.2+(2.0*NY))}
      {Out.toPort setCoords(Comp.state.3 +(2.0*NX2) Comp.state.4+(2.0*NY2))}
   end
end