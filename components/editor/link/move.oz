functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:"editor/link/move"
		     inPorts(move)
		     outPorts(output)
		     state(1:0.0 2:0.0 3:0.0 4:0.0)
		     procedure(proc{$ Ins Out Comp} IP in
				  IP = {Ins.move.get}
		                      % The position are saved to avoid getCoords at each time
				  case {Label IP}
				  of moveBegin then
				     {Out.output setCoords(Comp.state.1+IP.x Comp.state.2+IP.y Comp.state.3 Comp.state.4)}
				     Comp.state.1 := Comp.state.1 + IP.x
				     Comp.state.2 := Comp.state.2 + IP.y
				  [] moveEnd then
				     {Out.output setCoords(Comp.state.1 Comp.state.2 Comp.state.3+ IP.x Comp.state.4+IP.y)}
				     Comp.state.3 := Comp.state.3 + IP.x
				     Comp.state.4 := Comp.state.4 + IP.y
				     % [] moveEndMotion then
				     % 	{Out.output setCoords(Comp.state.1 Comp.state.2 IP.x IP.y)}
				     % 	Comp.state.3 := IP.x
				     % 	Comp.state.4 := IP.y
				  [] moveBeginPos then
				     {Out.output setCoords(IP.x IP.y Comp.state.3 Comp.state.4)}
				     Comp.state.1 := IP.x
				     Comp.state.2 := IP.y
				  [] moveEndPos then
				     {Out.output setCoords(Comp.state.1 Comp.state.2 IP.x IP.y)}
				     Comp.state.3 := IP.x
				     Comp.state.4 := IP.y
					
				  else
				     skip
				  end
			       end)
		    )
      }
   end
end