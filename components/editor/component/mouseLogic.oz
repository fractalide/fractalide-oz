functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/mouseLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of 'ButtonPress' then
				  Comp.state.dnd := false
				  {Out.dnd IP}
			       [] 'Motion' then
				  Comp.state.dnd := true
				  {Out.dnd IP}
			       [] 'ButtonRelease' then
				  if {Not Comp.state.dnd} then
				     {Out.show show}
				  end
				  {Out.dnd IP}
			       else skip
			       end
			    end)
		      )
		   outPorts(dnd show)
		   state(dnd:false)
		   )
      }
   end
end