functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:dndLogic
		     inPorts(input(proc{$ In Out Comp}
				      IP = {In.get}
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
			    )
		     outPorts(move position)
		     state(click:false x:0 y:0)
		    )
      }
   end
end