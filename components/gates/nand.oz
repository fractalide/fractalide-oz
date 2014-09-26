functor
export
   Component
define
   Component = comp(description:"nand Gate"
		    inPorts(a b)
		    outPorts(out)
		    procedure(proc {$ Ins Out Comp} A B in
				 A = {Ins.a.get}
				 B = {Ins.b.get}
				 case A#B
				 of 1#1 then {Out.out 0}
				 else {Out.out 1}
				 end
			    end)
		   )
end