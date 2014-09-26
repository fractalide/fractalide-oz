functor
export
   Component
define
   Component = comp(description:"concat"
		    inArrayPorts(input)
		    outPorts(out)
		    procedure(proc {$ Ins Out Comp}
				 Tab = {Record.map Ins.input fun {$ El} {El.get} end}
			      in
				 {Out.out {Record.toList Tab}}
			      end)
		   )
end