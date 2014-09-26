functor
import
   QTkHelper
export
   Component
define
   Component = comp(
		  description:"the QTk palceholder"
		  inPorts('in' place)
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp}
			       if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			       if {Ins.place.size} > 0 then {PlaceProc Ins.place Out Comp} end
			    end)
		  state(handle:_ buffer:nil t:nil)
		  )
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
	 B = {Record.adjoin IP placeholder(handle:H)}
	 {Out.out create(B)}
	 thread
	    Comp.state.t := {Thread.this}
	    {Wait H}
	    {QTkHelper.bindEvents H Comp.entryPoint}
	    Comp.state.handle := H
	    {QTkHelper.feedBuffer Out Comp}
	 end
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{PlaceProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then NIP in
	 NIP = {Record.adjoin IP set}
	 {QTkHelper.manageIP NIP Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
end