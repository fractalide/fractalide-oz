functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   fun {OutPortWrapper Out} 
      proc{$ send(N Msg Ack)}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createLink'
		   inPorts(input)
		   outPorts(out ml)
		   procedure(proc{$ Ins Out Comp}
				{InputProc Ins.input Out Comp}
			     end)
		   state(link:nil click:false)
		   )
      }
   end
   proc{InputProc In Out Comp} IP in
      IP = {In.get}
      case IP
      of createLink(entryPoint:BPoint x:X y:Y comp:OutComp) andthen {Not Comp.state.click} then L CompName in
	 CompName = {VirtualString.toAtom "link"#@Unique}
	 Unique := @Unique + 1
	 L = {SubComp.new CompName type "./components/editor/link.fbp"}
	 Comp.state.link := L
				  % Bind port and create it
	 {L bind(out {OutPortWrapper Out} out)}
	 {L bind('ERROR' {OutPortWrapper Out} out)}
				  % Set the initial position
	 {L send(moveBegin position(x:X y:Y) _)}
	 {L send(moveEnd position(x:X y:Y) _)}
	 {L send('in' lower _)}
	 {L start}
	 {L send('in' create(x:X y:Y outComp:OutComp entryPoint:BPoint) _)}
	 Comp.state.click := true
	 {Out.ml beginLink}
      [] createLink(entryPoint:EPoint x:X y:Y comp:InComp) andthen Comp.state.click then 
	 {Comp.state.link send(moveEnd position(x:X y:Y) _)}
				  % send info about the "real" port
	 {Comp.state.link send('in' inComp(comp:InComp ePoint:EPoint) _)}
	 Comp.state.link := nil
	 Comp.state.click := false
	 {Out.ml endLink}
      [] 'Motion'(state:_ x:X y:Y) andthen Comp.state.link \= nil andthen Comp.state.click then
	 {Comp.state.link send(moveEnd mousePosition(x:{Int.toFloat X} y:{Int.toFloat Y}) _)}
      else
	 skip
      end
   end
end