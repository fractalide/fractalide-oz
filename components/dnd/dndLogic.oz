functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:dndLogic
		     inPorts(input: proc {$ Buf Out NVar State Options}
				       IP = {Buf.get}
				    in
				       case {Label IP}
					  of 'ButtonPress' then
					  if IP.button == 1 then
					     State.click := true
					     State.lastX := IP.x
					     State.lastY := IP.y
					  end
				       [] 'ButtonRelease' then
					  if IP.button == 1 then
					     State.click := false
					  end
				       [] 'Motion' then
					  if State.click then
					     {Out.output move(IP.x-State.lastX IP.y-State.lastY)}
					     State.lastX := IP.x
					     State.lastY := IP.y
					  end
				       end
				    end)
		     outPorts(output)
		     state(click:false x:0 y:0)
		    )
      }
   end
end