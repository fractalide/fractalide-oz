functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/radiobutton'
		   inPorts(
		      'in'(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then H B in
				       B = {Record.adjoin IP radiobutton(handle:H
									 action:proc{$}
										   {QTkHelper.sendOut Out check({H get($)})}
										end
									)}
				       {Out.out create(B)}
				       {Wait H}
				       {QTkHelper.bindEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
				 end)
		      )
		   outPorts(out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   )}
   end
end