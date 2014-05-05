functor
import
   Comp at '../../lib/component.ozf'
   QTk at 'x-oz://system/wp/QTk.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/window'
		   inPorts(
		      actions_in(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then
				       % Create the window once
				       if {Not {IsDet Comp.state.handle}} then Desc TopLevel PhHandle in
					  Desc = td(placeholder(handle:PhHandle))
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
		      )
		   outPorts(actions_out)
		   outArrayPorts(action)
		   state(handle:_ phHandle:_ buffer:nil)
		   )}
   end
end