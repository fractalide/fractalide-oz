functor
import
   Comp at '../../../lib/component.ozf'
   QTkHelper at '../QTkHelper.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/canvas/image'
		   asynchInPorts(
		      'in'(proc{$ In Out Comp} IP in
				    IP = {In.get}
				    case {Label IP}
				    of create then H B in
				       B = {Record.adjoin {QTkHelper.recordIncInd IP} create(image handle:H)}
				       {Out.out B}
				       {Wait H}
				       {QTkHelper.bindBasicEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
			   end)
		      image(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       {QTkHelper.manageIP set(image:IP) Out Comp}
			    end)
		      )
		   outPorts(out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   var(image)
		   )}
   end
end