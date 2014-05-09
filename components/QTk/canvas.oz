functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/canvas'
		   inPorts('in' widget)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(
		      proc{$ Ins Out Comp}
			 if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			 if {Ins.widget.size} > 0 then {WidgetProc Ins.widget Out Comp} end
		      end
		      )
		   state(handle:_ buffer:nil)
		   )}
   end
   proc {InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP canvas(handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc {WidgetProc In Out Comp} IP in
      IP = {In.get}
      {QTkHelper.manageIP IP Out Comp}
   end
   end