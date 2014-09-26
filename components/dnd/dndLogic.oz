functor
export
   Component
define
   Component = comp(description:"manage the drag&drop"
		    inPorts(input)
		    outPorts(move position)
		    procedure(proc{$ Ins Out Comp}
				 IP = {Ins.input.get}
			      in
				 case {Label IP}
				 of 'ButtonPress' then
				    if IP.button == 1 then
				       Comp.state.click := true
				       Comp.state.lastX := IP.x
				       Comp.state.lastY := IP.y
				    end
				 [] 'ButtonRelease' then
				    if IP.button == 1 then
				       Comp.state.click := false
				    end
				 [] 'Motion' then
				    if Comp.state.click then
				       {Out.move move(IP.x-Comp.state.lastX IP.y-Comp.state.lastY)}
				       {Out.position position(IP.x IP.y)}
				       Comp.state.lastX := IP.x
				       Comp.state.lastY := IP.y
				    end
				 end
			      end)
		    state(click:false x:0 y:0)
		   )
end