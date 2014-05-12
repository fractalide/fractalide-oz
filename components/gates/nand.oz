functor
import
   Comp at '../../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:nand
		     inPorts(a b)
		     outPorts(out)
		     procedure(proc {$ Ins Out Comp} A B in
				  A = {Ins.a.get}
				  B = {Ins.b.get}
				  case Comp.var.a#Comp.var.b
				  of 1#1 then {Out.out 0}
				  else {Out.out 1}
				  end
			       end)
		    )
      }
   end
end