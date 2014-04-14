functor
import
   Comp at '../../lib/component.ozf'
   QTk at 'x-oz://system/wp/QTk.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:image
		   outPorts(output)
		   inPorts(input(proc {$ In Out Comp} NOptions in
				     NOptions = {Record.adjoin {In.get} photo}
				     {Out.output {QTk.newImage NOptions}}
				 end)
			  )
		   )
      }
   end
end
     