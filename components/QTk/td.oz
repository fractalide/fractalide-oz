functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/td'
		   inPorts('in')
		   inArrayPorts(place)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				{Record.forAllInd Ins.place
				 proc{$ Name Buf}
				    if {Buf.size} > 0 then {PlaceProc Name Ins.place Out Comp} end
				 end}
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP grid(handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Comp.entryPoint}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{PlaceProc Sub Ins Out Comp} IP in
      IP = {Ins.Sub.get}
      if {Label IP} == create then NIP in
	 NIP = configure(IP.1 column:1 row:Sub)
	 {QTkHelper.manageIP NIP Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
end