functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   fun {OutPortWrapper Out} 
      proc{$ send(N Msg Ack)}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createLink'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case IP
			       of createLink(entryPoint:BPoint x1:_ x2:X y:Y side:left) andthen {Not Comp.state.click} then L in
				  L = {SubComp.new test type "./components/editor/link.fbp"}
				  Comp.state.link := L
				  % Bind port and create it
				  {L bind(ui_out {OutPortWrapper Out} widget_out)}
				  {L bind(actions_out {OutPortWrapper Out} actions_out)}
				  {L send(actions_in lower _)}
				  % Set the initial position
				  {L send(actions_in moveBegin(x:X y:Y) _)}
				  {L send(actions_in moveEnd(x:X y:Y) _)}
				  {L start}
				  {L send(ui_in startline(x:X y:Y) _)}
				  Comp.state.bPoint := BPoint
				  Comp.state.click := true
			       [] createLink(entryPoint:EPoint x1:X x2:_ y:Y side:right) andthen Comp.state.click andthen Comp.state.link \= nil andthen Comp.state.bPoint \= nil then
				  % The port is binded to an input port
				  % Bind for the message moveBegin and moveEnd
				  {Comp.state.bPoint bind(action#moveBegin Comp.state.link actions_in)}
				  {EPoint bind(action#moveEnd Comp.state.link actions_in)}
				  {Comp.state.link send(actions_in moveEndMotion(x:X y:Y) _)}
				  Comp.state.link := nil
				  Comp.state.bPoint := nil
				  Comp.state.click := false
				  % TODO : ButtonRelease to discard the line
				  % Issue : there is an ButtonRelease when createLink event is launched...
                               % [] 'ButtonRelease'(button:3 x:_ y:_) andthen Comp.state.click == true then
			       % 	  {Comp.state.link send(actions_in delete _)}
			       % 	  Comp.state.link := nil
			       % 	  Comp.state.bPoint := nil
			       % 	  Comp.state.click := false
			       [] 'Motion'(state:_ x:X y:Y) andthen Comp.state.link \= nil andthen Comp.state.click then
				  {Comp.state.link send(actions_in moveEndMotion(x:{Int.toFloat X} y:{Int.toFloat Y}) _)}
			       else
				  skip
			       end
			    end)
		      )
		   outPorts(widget_out actions_out)
		   state(link:nil bPoint:nil click:false)
		   )
      }
   end
end