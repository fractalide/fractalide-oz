functor
import
   QTkHelper
export
   Component
define
   proc {Create Out Comp}
      if Comp.state.frame \= nil andthen Comp.state.init \= nil then RevI RevF H B in
	 if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
	 RevI = {Reverse Comp.state.init}
	 RevF = {Reverse Comp.state.frame}
	 B = {Record.adjoin RevI.1 scrollframe(RevF.1 handle:H)}
	 {Out.out create(B)}
	 thread
	    Comp.state.t := {Thread.this}
	    {Wait H}
	    {QTkHelper.bindEvents H Comp.entryPoint}
	    Comp.state.handle := H
	    {QTkHelper.feedBuffer Out Comp}
	    Comp.state.init := {Reverse RevI.2}
	    Comp.state.frame := {Reverse RevF.2}
	 end
      end
   end
   Component = comp(
		  description:"the QTk scrollframe"
		  inPorts('in' frame)
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp}
			       if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			       if {Ins.frame.size} > 0 then {FrameProc Ins.frame Out Comp} end
			    end)
		  state(handle:_ buffer:nil init:nil frame:nil t:nil)
		  )
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then
	 Comp.state.init := IP | Comp.state.init
	 {Create Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{FrameProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then
	 Comp.state.frame := IP.1 | Comp.state.frame
	 {Create Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
end