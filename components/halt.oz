functor
export
   Component
define
   Component = comp(description:"halt the graph"
		    inPorts('in')
		    procedure(proc{$ Ins Out Comp}
				 _ = {Ins.'in'.get}
				 {Comp.parentEntryPoint send('HALT' halt _)}
			      end)
		   )
end