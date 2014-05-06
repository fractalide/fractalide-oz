functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   proc {Create Out Comp}
      if Comp.state.frame \= nil andthen Comp.state.init \= nil then H B in 
	 B = {Record.adjoin Comp.state.init scrollframe(Comp.state.frame handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
	 Comp.state.frame := nil
	 Comp.state.init := nil
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
				 Comp.state.init := IP
				 {Create Out Comp}
			      else
				 {QTkHelper.manageIP IP Out Comp}
			      end
			   end)
		      frame(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of create then
				  Comp.state.frame := IP.1
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