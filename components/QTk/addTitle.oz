functor
export
   Component
define
   Component = comp(description:"add the title (specified with IIP) to the IP"
		    inPorts(input)
		    outPorts(output)
		    procedure(proc{$ Ins Out Comp} IP in
				 IP = {Ins.input.get}
				 {Out.output create({Record.adjoinAt IP.1 title Comp.options.title})}
			      end)
		    options(title:_)
		   )
end