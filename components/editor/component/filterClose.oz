functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/filterClose"
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of getEPFilter then
				  Comp.state.ep := IP.1
			       [] closePorts andthen {HasFeature IP comp} then
				  if IP.comp \= Comp.state.ep then
				     {Out.output IP}
				  end
			       else
				  {Out.output IP}
			       end
			    end)
		      )
		   outPorts(output)
		   state(ep:_)
		   )
      }
   end
end