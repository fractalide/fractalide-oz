functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'
   QTkHelper
export
   Component
define
   Component = comp(
		  description:"the QTk window"
		  inPorts('in')
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp} IP in
			       IP = {Ins.'in'.get}
			       case {Label IP}
				of create then
				       % Create the window once
				  if {Not {IsDet Comp.state.handle}} then Desc TopLevel PhHandle in
				     Desc = td(placeholder(glue:nsew handle:PhHandle))
				      TopLevel = {QTk.build Desc}
				     {TopLevel show}
				     Comp.state.phHandle := PhHandle
				     Comp.state.handle := TopLevel
				     {QTkHelper.feedBuffer Out Comp}
				  end
				  {Comp.state.phHandle set(IP.1)}
			       else
				  {QTkHelper.manageIP IP Out Comp}
			       end
			     end)
		  state(handle:_ phHandle:_ buffer:nil)
		  )
end