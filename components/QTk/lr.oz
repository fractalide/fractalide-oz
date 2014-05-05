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
		   asynchInArrayPorts(
		      actions_in(proc{$ Sub IP Out Comp}
				    case {Label IP}
				    of create andthen Sub == lr then H B in
				       B = {Record.adjoin IP grid(handle:H)}
				       {Out.actions_out create(B)}
				       {Wait H}
				       {QTkHelper.bindEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    else
				       if {Label IP} == create then NIP in
					  NIP = configure(IP.1 column:Sub row:1)
					  {QTkHelper.manageIP NIP Out Comp}
				       else
					  {QTkHelper.manageIP IP Out Comp}
				       end
				    end
				 end)
		      )
		   outPorts(actions_out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   )}
   end
end