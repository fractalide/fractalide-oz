functor
import
   Comp at '../../../lib/component.ozf'
   QTkHelper at '../QTkHelper.ozf'
export
   new: CompNewArgs
define
   proc {Create Out Comp}
      if Comp.state.window \= nil andthen Comp.state.init \= nil then H B in 
	 B = {Record.adjoin {QTkHelper.recordIncInd Comp.state.init} create(window window:Comp.state.window handle:H)}
	 {Out.out B}
	 {Wait H}
	 {QTkHelper.bindBasicEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
	 Comp.state.window := nil
	 Comp.state.init := nil
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
				       Comp.state.init := IP
				       {Create Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
			   end)
		      window(proc{$ In Out Comp} IP in
				IP = {In.get}
				case {Label IP}
				of create then
				   Comp.state.window := IP.1
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