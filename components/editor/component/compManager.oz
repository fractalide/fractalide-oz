functor
import
   CompLib at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {CompLib.new comp(
		   name:Name type:'components/editor/component/compManager'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of create then
				  Comp.state.comp := {CompLib.new comp(name:IP.name
								       type:dummy)}
			       [] beginLink then
				  {Out.output {Record.adjoin ep(comp:Comp.state.comp) IP}}
			       [] endLink then
				  {Out.output {Record.adjoin ep(comp:Comp.state.comp) IP}}
			       [] newComp then NState in
				  % Delete old port
				  {Out.newInPort delete}
				  {Out.newOutPort delete}
				  % Stop the old com
				  {Comp.state.comp stop}
				  % New one
				  NState = {IP.1 getState($)}
				  % Add new port
				  {Record.forAllInd NState.inPorts
				   proc {$ I P} IsArray in
				      IsArray = if {Label NState} == component then
						   if {Label P} \= arrayPort then false else true end
						elseif {Label NState} == subcomponent andthen P \= nil then PortComp in 
						   PortComp = {(P.1).1 getState($)}
						   if {HasFeature PortComp.inPorts (P.1).2} andthen {Label PortComp.inPorts.((P.1).2)} == arrayPort then true
						   else false end
						else
						   false
						end
				      if {Not IsArray} then 
					 {Out.newInPort add({Atom.toString I})}
				      else
					 {Out.newInPort addArrayPort({Atom.toString I})}
				      end
				   end}
				  {Record.forAllInd NState.outPorts
				   proc {$ I P} IsArray in
				      IsArray = if {Label NState} == component then
						   if {Label P} \= arrayPort then false else true end
						elseif {Label NState} == subcomponent andthen P \= nil then PortComp in 
						   PortComp = {(P.1).1 getState($)}
						   if {HasFeature PortComp.outPorts (P.1).2} andthen {Label PortComp.outPorts.((P.1).2)} == arrayPort then true
						   else false end
						else
						   false
						end
				      if {Not IsArray} then 
					 {Out.newOutPort add({Atom.toString I})}
				      else
					 {Out.newOutPort addArrayPort({Atom.toString I})}
				      end
				   end}
				
				  % Replace the entry point
				  Comp.state.comp := IP.1
			       [] start then
				  {Comp.state.comp start}
			       [] stop then
				  {Comp.state.comp stop}
			       [] addinArrayPort then
				  {Comp.state.comp addinArrayPort(IP.1 IP.2)}
			       end
			    end)
		      )
		   outPorts(output delete newInPort newOutPort)
		   state(comp:_)
		   )
      }
      
   end
end