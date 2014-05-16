functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createLinkLogic'
		   inPorts(click pos)
		   outPorts(out)
		   options(canvas:_)
		   procedure(proc{$ Ins Out Comp} IP Pos X Y DistX DistY in
				IP = {Ins.click.get}
				Pos = {Ins.pos.get}.1
				X = {Comp.options.canvas canvasx(IP.x $)}
				Y = {Comp.options.canvas canvasy(IP.y $)}
				DistX = {Abs X - {Float.toInt Pos.1}}
				DistY = {Abs Y - {Float.toInt Pos.2.1}}
				if DistX < 40 andthen DistY < 40 then
				   {Out.out displayComp(Comp.parentEntryPoint)}
				elseif (DistX >= 40) %DistX =< 50 for discard the coin
				   orelse (DistY >= 40) then %DstyY =< for discard the coin
				   {Out.out createLink(entryPoint:Comp.parentEntryPoint x:Pos.1 y:Pos.2.1)}
				end
			     end)
		   )
      }
   end
end