functor
export
   Component
define
   Component = comp(description:"send the option arg on the output port"
		    outPorts(output)
		    procedure(proc{$ Ins Out Comp}
				 {Out.output Comp.options.arg}
			      end)
		    options(arg:_)
		   )
end

   