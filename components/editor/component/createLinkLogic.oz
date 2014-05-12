functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createLinkLogic'
		   inPorts(input)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.input.get}
				case IP
				of createLink(entryPoint:BPoint x1:X1 x2:X2 y:Y side:Side name:Name) then
				   if Side == left then
				      {Out.output beginLink(entryPoint:BPoint x:X2 y:Y name:Name)}
				   else
				      {Out.output endLink(entryPoint:BPoint x:X1 y:Y name:Name)}
				   end
				end
			     end)
		   )
      }
   end
end