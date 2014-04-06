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
		   inPorts(input: proc {$ Buf Out NVar State Options} NOptions in
				     NOptions = {Record.adjoin {Record.adjoin {Buf.get} Options} photo}
				     {Out.output {QTk.newImage NOptions}}
				  end)
		   )
      }
   end
end
     