functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/lr'
		   asynchInPorts(
		      'in'(proc{$ In Out Comp} IP in
			      IP = {In.get}
			      case {Label IP}
			      of create then H B in
				 B = {Record.adjoin IP grid(handle:H)}
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
		   asynchInArrayPorts(
		      place(proc{$ Sub Ins Out Comp} IP in
			       IP = {Ins.Sub.get}
			       if {Label IP} == create then NIP in
				  NIP = configure(IP.1 column:Sub row:1)
				  {QTkHelper.manageIP NIP Out Comp}
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