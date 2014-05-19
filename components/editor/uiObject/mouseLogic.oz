functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/uiObject/mouseLogic'
		   inPorts('in')
		   outPorts(move out sc)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				case {Label IP}
				of 'Enter' then
				   {Out.out inObject}
				[] 'Leave' then
				   {Out.out outObject}
				[] 'ButtonPress' then
				   Comp.state.dnd := false
				   Comp.state.click := true
				   Comp.state.lastX := IP.x
				   Comp.state.lastY := IP.y
				[] 'Motion' then
				   if Comp.state.click then MX MY in
				      Comp.state.dnd := true
				      MX = IP.x - Comp.state.lastX
				      MY = IP.y - Comp.state.lastY
				      {Out.move move(MX MY)}
				      Comp.state.lastX := IP.x
				      Comp.state.lastY := IP.y
				   end
				[] 'ButtonRelease' then
				   if {Not Comp.state.dnd} then 
				      {Out.sc IP}
				   end
				   Comp.state.click := false
				   Comp.state.dnd := false
				end
			     end)
		   state(dnd:false click:false lastX:0 lastY:0)
		   )
      }
   end
end