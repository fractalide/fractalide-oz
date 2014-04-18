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
			       end
			    end)
		      )
		   outPorts(output)
		   state(comp:_)
		   )
      }
   end
end