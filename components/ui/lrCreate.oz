functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:trCreate
		   outPorts(eo opt uo)
		   inArrayPorts(ui: proc {$ Buffers Out NVar State Options} Rec H in
				       Rec = {List.toRecord lr
					      {List.mapInd Buffers
					       fun {$ Ind El} E in
						  E = {El.get}
						  Ind#E
					       end
					      }
					     }
				       {Out.uo {Record.adjoinAt Rec handle H}}
				       {Wait H}
				       {Out.opt opt(handle:H)}
				    end)
		   )
      }
   end
end
     