functor
export
   Component
define
   Component = comp(description:"ipEdit"
		    inPorts(input)
		    outPorts(out)
		    procedure(proc{$ Ins Out Comp} Msg NMsg in
				 Msg = {Ins.input.get}
				 NMsg = {Record.map Comp.options.text
					 fun {$ E} if {IsDet E} then E else Msg end end}
				 {Out.out NMsg}
			      end)
		    options(text:_)
		   )
end