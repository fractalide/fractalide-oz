functor
import
   Comp at '../../lib/component.ozf'
   OS
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:buttonLogic
		     inPorts(input: proc {$ Buf Out NVar State Options}
				       IP = {Buf.get}
				    in
				       case {Label IP}
					  of 'KeyPress' then
					  if IP.key == 37 then
					     State.ctrl := true
					  elseif IP.key == 50 then
					     State.maj := true
					  end
				       [] 'KeyRelease' then
					  if IP.key == 37 then
					     State.ctrl := false
					  elseif IP.key == 50 then
					     State.maj := false
					  end
				       [] 'button_clicked' then
					  if State.ctrl andthen State.maj then Color in
					     Color = c(({OS.rand} mod 255) ({OS.rand} mod 255) ({OS.rand} mod 255))
					     {Out.color set(bg:blue activebackground:blue)}
					  else
					     {Out.click IP}
					  end
				       end
				    end)
		     outPorts(click color)
		     state(maj:false ctrl:false)
		    )
      }
   end
end