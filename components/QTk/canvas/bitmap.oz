functor
import
   Comp at '../../../lib/component.ozf'
   QTkHelper at '../QTkHelper.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/canvas/bitmap'
		   inPorts(
		      'in'(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then H B in
				       B = {Record.adjoin {QTkHelper.recordIncInd IP} create(bitmap handle:H)}
				       {Out.out B}
				       {Wait H}
				       {QTkHelper.bindBasicEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
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