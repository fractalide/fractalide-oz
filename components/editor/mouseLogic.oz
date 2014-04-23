functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/mouseLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of 'ButtonPress' andthen Comp.state.outComp then
				  {Out.output IP}
			       [] 'ButtonRelease' andthen Comp.state.outComp then
				  {Out.output IP}
			       [] 'Motion' andthen Comp.state.outComp then
				  {Out.output IP}
			       [] inComponent then
				  Comp.state.outComp := false
			       [] outComponent then
				  Comp.state.outComp := true
			       else
				  skip
			       end
			    end)
		      )
		   outPorts(output)
		   state(outComp:true)
		   )
      }
   end
end