functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/label'
		   inPorts('in')
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				case {Label IP}
				of create then H B in
				   B = {Record.adjoin IP label(handle:H)}
				   {Out.out create(B)}
				   {Wait H}
				   {QTkHelper.bindEvents H Comp.entryPoint}
				   Comp.state.handle := H
				   {QTkHelper.feedBuffer Out Comp}
				else
				   {QTkHelper.manageIP IP Out Comp}
				end
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
end