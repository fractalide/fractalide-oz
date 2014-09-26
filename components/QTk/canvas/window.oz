functor
import
   QTkHelper at '../QTkHelper.ozf'
export
   Component
define
   proc {Create Out Comp}
      if Comp.state.window \= nil andthen Comp.state.init \= nil then RevI RevW H B in
	 if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
	 RevI = {Reverse Comp.state.init}
	 RevW = {Reverse Comp.state.window}
	 B = {Record.adjoin {QTkHelper.recordIncInd RevI.1} create(window window:RevW.1 handle:H)}
	 {Out.out B}
	 thread
	    Comp.state.t := {Thread.this}
	    {Wait H}
	    {QTkHelper.bindBasicEvents H Comp.entryPoint}
	    Comp.state.handle := H
	    {QTkHelper.feedBuffer Out Comp}
	    Comp.state.window := {Reverse RevW.2}
	    Comp.state.init := {Reverse RevI.2}
	 end
      end
   end
   Component = comp(
		  description:"The QTk canvas window"
		  inPorts('in' window)
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp}
			       if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			       if {Ins.window.size} > 0 then {WindowProc Ins.window Out Comp} end
			    end)
		  state(handle:_ buffer:nil init:nil window:nil t:nil)
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
   proc{WindowProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then
	 Comp.state.window := IP.1 | Comp.state.window
	 {Create Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
end