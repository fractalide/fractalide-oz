functor
export
   Component
define
   Component = comp(description:"discard the IP"
		    inPorts(input)
		    procedure(proc{$ Ins Out Comp}
				 _ = {Ins.input.get}
			      end)
		   )
end