functor
export
   Component
define
   Component = comp(description:"adder"
		    inArrayPorts(input)
		    procedure(proc{$ Ins Out Component}
				 {Out.output {Record.foldL Ins.input
					      fun{$ Acc In}
						 Acc+{In.get}
					      end
					      0}}
			      end)
		    outPorts(output)
		   )
end