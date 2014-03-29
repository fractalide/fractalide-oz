functor
import
   Comp at '../../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:nand
		     inPorts(
			a: proc{$ Buffer Out NVar State Options}
			      NVar.a = {Buffer.get}
			   end
			b: proc{$ Buffer Out NVar State Options}
			      NVar.b = {Buffer.get}
			   end
			)
		     outPorts(out)
		     procedures(proc {$ Out NVar State Options}
				   case NVar.a#NVar.b
				   of 1#1 then {Out.out 0}
				   else {Out.out 1}
				   end
				end)
		     var(a b)
		    )
      }
   end
end