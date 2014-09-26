functor
export
   Component
define
   Component = comp(description:"kill after 5 faillures"
		    inPorts(input)
		    outPorts(output)
		    procedure(proc{$ Ins Out Comp} IP in
				 IP = {Ins.input.get}
				 if {HasFeature Comp.state.cache IP.name} andthen Comp.state.cache.(IP.name) >= 5 then
				    {IP.entryPoint stop}
				    {Out.output stop_component(IP)}
				 elseif {HasFeature Comp.state.cache IP.name} then
				    Comp.state.cache := {Record.adjoinAt Comp.state.cache IP.name Comp.state.cache.(IP.name)+1}
				    {Out.output IP}
				 else
				    Comp.state.cache := {Record.adjoinAt Comp.state.cache IP.name 1}
				    {Out.output IP}
				 end
				 
			      end)
		     state(cache:cache())
		   )
end