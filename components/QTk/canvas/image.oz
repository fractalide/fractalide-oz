functor
import
   Comp at '../../../lib/component.ozf'
   QTkHelper at '../QTkHelper.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/canvas/image'
		   inPorts('in' image)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				if {Ins.image.size} > 0 then {ImageProc Ins.image Out Comp} end
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin {QTkHelper.recordIncInd IP} create(image handle:H)}
	 {Out.out B}
	 {Wait H}
	 {QTkHelper.bindBasicEvents H Comp.entryPoint}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{ImageProc In Out Comp} IP in
      IP = {In.get}
      {QTkHelper.manageIP set(image:IP) Out Comp}
   end
end