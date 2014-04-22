functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/linkLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of outComp then
				  Comp.state.outComp := IP.comp
				  Comp.state.outPortName := IP.name
			       [] inComp then
				  Comp.state.inComp := IP.comp
				  Comp.state.inPortName := IP.name
				  {Comp.state.outComp bind(Comp.state.outPortName IP.comp IP.name)}
			       else skip end
			    end)
		      )
		   state(outComp:nil outPortName:nil
			 inComp:nil inPortName:nil)
		   )
      }
   end
end