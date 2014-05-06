functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   proc {Create Out Comp}
      if Comp.state.frame \= nil andthen Comp.state.init \= nil then RevI RevF H B in
	 RevI = {Reverse Comp.state.init}
	 RevF = {Reverse Comp.state.frame}
	 B = {Record.adjoin RevI.1 scrollframe(RevF.1 handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
	 Comp.state.init := {Reverse RevI.2}
	 Comp.state.frame := {Reverse RevF.2}
      end
   end
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/scrollframe'
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
		      frame(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of create then
				  Comp.state.frame := IP.1 | Comp.state.frame
				  {Create Out Comp}
			       else
				  {QTkHelper.manageIP IP Out Comp}
			       end
			    end)
		      )
		   outPorts(out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil init:nil frame:nil)
		   )}
   end
end