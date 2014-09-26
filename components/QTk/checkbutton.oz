functor
import
   QTkHelper
export
   Component
define
   Component = comp(
		  description:"the QTk checkbutton"
		  inPorts('in')
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp} IP in
			       IP = {Ins.'in'.get}
			       case {Label IP}
			       of create then H B in
				  if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
				  B = {Record.adjoin IP checkbutton(handle:H
								    action:proc{$}
									      {Comp.entryPoint send('in' check({H get($)}) _)}
									   end
								   )}
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
			    end)
		  state(handle:_ buffer:nil t:nil)
		  )
end