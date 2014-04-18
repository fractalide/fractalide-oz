functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createLinkLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case IP
			       of createLink(entryPoint:BPoint x1:X1 x2:X2 y:Y side:Side name:Name) then
				  if Side == left then
				     {Out.output beginLink(entryPoint:BPoint x:X2 y:Y name:Name)}
				  else
				     {Out.output endLink(entryPoint:BPoint x:X1 y:Y name:Name)}
				  end
			       else
				  {Out.output IP}
			       end
			    end)
		      )
		   outPorts(output)
		   )
      }
   end
end