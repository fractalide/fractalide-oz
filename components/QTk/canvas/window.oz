functor
import
   Comp at '../../../lib/component.ozf'
   QTkHelper at '../QTkHelper.ozf'
export
   new: CompNewArgs
define
   proc {Create Out Comp}
      if Comp.state.window \= nil andthen Comp.state.init \= nil then RevI RevW H B in
	 RevI = {Reverse Comp.state.init}
	 RevW = {Reverse Comp.state.window}
	 B = {Record.adjoin {QTkHelper.recordIncInd RevI.1} create(window window:RevW.1 handle:H)}
	 {Out.out B}
	 {Wait H}
	 {QTkHelper.bindBasicEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
	 Comp.state.window := {Reverse RevW.2}
	 Comp.state.init := {Reverse RevI.2}
      end
   end
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/canvas/bitmap'
		   asynchInPorts(
		      'in'(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then
				       Comp.state.init := IP | Comp.state.init
				       {Create Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
			   end)
		      window(proc{$ In Out Comp} IP in
				IP = {In.get}
				case {Label IP}
				of create then
				   Comp.state.window := IP.1 | Comp.state.window
				   {Create Out Comp}
				else
				   {QTkHelper.manageIP IP Out Comp}
				end
			     end)
		      )
		   outPorts(out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil init:nil window:nil)
		   )}
   end
end