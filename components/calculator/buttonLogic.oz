functor
import
   OS
export
   Component
define
   Component = comp(description:"button logic for calculator"
		    inPorts(input)
		    outPorts(click color)
		    procedure(proc{$ Ins Out Comp}
				 {InputProc Ins.input Out Comp}
			      end)
		    state(maj:false ctrl:false)
		   )
   proc {InputProc Buf Out Comp}
      IP = {Buf.get}
   in
      case {Label IP}
      of 'KeyPress' then
	 if IP.key == 37 then
	    Comp.state.ctrl := true
	 elseif IP.key == 50 then
	    Comp.state.maj := true
	 end
      [] 'KeyRelease' then
	 if IP.key == 37 then
	    Comp.state.ctrl := false
	 elseif IP.key == 50 then
	    Comp.state.maj := false
	 end
      [] 'button_clicked' then
	 if Comp.state.ctrl andthen Comp.state.maj then Color R in
	    R = fun{$} T in
		   T = {OS.rand} mod 255
		   if T < 0 then ~T else T end
		end
	    Color = c({R} {R} {R})
	    {Out.color set(bg:Color activebackground:Color)}
	 else
	    {Out.click IP}
	 end
      end
   end
end