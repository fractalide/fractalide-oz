functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:tdCreate
		   outPorts(out)
		   inArrayPorts(input: proc {$ Buffers Out NVar State Options} Rec in
				       Rec = {List.toRecord lr
					      {List.mapInd Buffers
					       fun {$ Ind El} E in
						  E = {El.get}
						  Ind#E
					       end
					      }
					     }
				       {Out.out fun {$ _} Rec end}
				    end)
		   )
      }
   end
end
     