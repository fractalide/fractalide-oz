functor
import
   QTkHelper at '../QTkHelper.ozf'
export
   Component
define
   Component = comp(
		  description:"the QTK canvas image"
		  inPorts('in' image)
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp}
			       if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			       if {Ins.image.size} > 0 then {ImageProc Ins.image Out Comp} end
			    end)
		  state(handle:_ buffer:nil t:nil)
		  )
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
	 B = {Record.adjoin {QTkHelper.recordIncInd IP} create(image handle:H)}
	 {Out.out B}
	 thread
	    Comp.state.t := {Thread.this}
	    {Wait H}
	    {QTkHelper.bindBasicEvents H Comp.entryPoint}
	    Comp.state.handle := H
	    {QTkHelper.feedBuffer Out Comp}
	 end
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{ImageProc In Out Comp} IP in
      IP = {In.get}
      {QTkHelper.manageIP set(image:IP) Out Comp}
   end
end