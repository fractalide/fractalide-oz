functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
   System
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/button'
		   inPorts(
		      actions_in(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then H B in
				       B = {Record.adjoin IP button(handle:H
								    action:proc{$}
									      {QTkHelper.sendOut Out button_clicked}
									      {System.show click}
									   end
								   )}
				       {Out.actions_out create(B)}
				       {Wait H}
				       {QTkHelper.bindEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
				 end)
		      )
		   outPorts(actions_out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   )}
   end
end