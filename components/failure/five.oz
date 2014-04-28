functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:'failure/five'
		     inPorts(input(proc{$ In Out Comp} IP in
				      IP = {In.get}
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
			    )
		     outPorts(output)
		     state(cache:cache())
		    )}
   end
end