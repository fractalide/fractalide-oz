functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/td'
		   asynchInArrayPorts(
		      'in'(proc{$ Sub Ins Out Comp} IP in
				    IP = {Ins.Sub.get}
				    case {Label IP}
				    of create andthen Sub == td then H B in
				       B = {Record.adjoin IP grid(handle:H)}
				       {Out.out create(B)}
				       {Wait H}
				       {QTkHelper.bindEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    else
				       if {Label IP} == create then NIP in
					  NIP = configure(IP.1 column:1 row:Sub)
					  {QTkHelper.manageIP NIP Out Comp}
				       else
					  {QTkHelper.manageIP IP Out Comp}
				       end
				    end
				 end)
		      )
		   outPorts(out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   )}
   end
end