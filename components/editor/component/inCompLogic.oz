functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/inCompLogic"
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case  {Label IP}
			       of inComponent then
				  Comp.state.inside := true
				  {Out.output inComponent}
			       [] outComponent then
				  Comp.state.inside := false
				  if {Not Comp.state.click} then {Out.output outComponent} end
			       [] 'ButtonPress' andthen IP.button == 1 then
				  Comp.state.click := true
				  {Out.output inComponent}
			       [] 'ButtonRelease' andthen IP.button == 1 then
				  Comp.state.click := false
				  if {Not Comp.state.inside} then {Out.output outComponent} end
			       end
				  
			    end)
		      )
		   outPorts(output)
		   state(inside:false click:false)
		   )
      }
   end
end