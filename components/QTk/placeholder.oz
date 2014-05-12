functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/button'
		   inPorts('in' place)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				if {Ins.place.size} > 0 then {PlaceProc Ins.place Out Comp} end
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP placeholder(handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
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