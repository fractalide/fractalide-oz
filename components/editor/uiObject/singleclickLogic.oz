functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/uiObject/createLinkLogic'
		   inPorts(click pos)
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp} IP Pos in
				IP = {Ins.click.get}
				Pos = {Ins.pos.get}.1
				if IP.button == 1 then 
				   {Out.out displayObj(Comp.parentEntryPoint)}
				elseif IP.button == 3 then
				   {Out.out createLink(entryPoint:Comp.parentEntryPoint x:Pos.1 y:Pos.2.1)}
				else
				   skip
				end
			     end)
		   )
      }
   end
end