functor
export
   Component
define
   Component = comp(description:"Add two string"
		     inArrayPorts(input)
		     procedure(proc{$ Ins Out Component}
				  {Out.output {Record.foldL Ins.input
					       fun{$ Acc X} E I in
						  E = {X.get}.1
						  if {String.isInt E} then
						     I = {String.toInt E}
						  else
						     I = 0
						  end
						  Acc+I
					       end
					       0}}
			       end)
		     outPorts(output)
		    )
end