functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/mouseLogic'
		   inPorts('in')
		   outPorts(dnd out disp)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				case {Label IP}
				of 'Enter' then
				   {Out.out inComponent}
				[] 'Leave' then
				   {Out.out outComponent}
				[] 'ButtonPress' then
				   Comp.state.dnd := false
				   Comp.state.click := true
				   {Out.dnd IP}
				[] 'Motion' then
				   Comp.state.dnd := true
				   {Out.dnd IP}
				[] 'ButtonRelease' then
				   if {Not Comp.state.dnd} then
				      {Out.disp displayComp(Comp.parentEntryPoint)}
				   end
				   {Out.dnd IP}
				end
			     end)
		   state(dnd:false click:false)
		   )
      }
   end
end