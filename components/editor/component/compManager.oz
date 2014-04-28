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
				   proc {$ I P}
				      if {Label P} \= arrayPort then
					 {Out.newInPort add({Atom.toString I})}
				      else
					 {Out.newInPort addArrayPort({Atom.toString I})}
				      end
				   end}
				  {Record.forAllInd NState.outPorts
				   proc {$ I P}
				      if {Label P} \= arrayPort then
					 {Out.newOutPort add({Atom.toString I})}
				      else
					 {Out.newOutPort addArrayPort({Atom.toString I})}
				      end
				   end}

				  
				  {Out.newInPort show}
				  {Out.newInPort show}
				  {Out.newOutPort show}
				  {Out.newOutPort show}
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