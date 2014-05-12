functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/filterClose"
		   inPorts(input)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.input.get}
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
		   state(ep:_)
		   )
      }
   end
end