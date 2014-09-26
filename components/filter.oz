functor
export
   Component
define
   Component = comp(description:"filter the received IP with the function in options"
		    inPorts(input)
		    outPorts(output)
		    options(p:_)
		    procedure(proc{$ Ins Out Comp} IP in
				 IP = {Ins.input.get}
				 if {Comp.options.p IP} then
				    {Out.output IP}
				 end
			      end)
		    )
end