functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
   System
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/create'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       {System.show IP}
			       case IP
			       of beginLink(entryPoint:BPoint x:X y:Y canvas:Canvas) then L in
				  {System.show beginLink}
				  L = {SubComp.new test type "/home/denis/fractalide/fractallang/components/editor/link.fbp"}
				  Comp.state.link := L
				  {L bind(ui_out Canvas actions_in)}
				  {L bind(actions_out Canvas actions_in)}
				  {L start}
				  {L send(ui_in startline(x:X y:Y) _)}
				  Comp.state.bPoint := BPoint
				  Comp.state.click := true
				  Comp.state.x := X
				  Comp.state.y := Y
				  {System.show endBeginLink}
			       [] endLink(entryPoint:EPoint x:_ y:_) andthen Comp.state.link \= nil andthen Comp.state.bPoint \= nil then
				  {System.show endlink}
				  {Comp.state.bPoint bind(action#moveBegin Comp.state.link actions_in)}
				  {EPoint bind(action#moveEnd Comp.state.link actions_in)}
				  Comp.state.link := nil
				  Comp.state.bPoint := nil
				  Comp.state.click := false
				  {System.show endEndlink}
			       [] 'ButtonRelease'(button:3 x:_ y:_) then
				  {Comp.state.link send(actions_in delete _)}
				  Comp.state.link := nil
				  Comp.state.bPoint := nil
				  Comp.state.click := false
				  {System.show endbuttonrelease}
			       [] 'Motion'(state:_ x:X y:Y) andthen Comp.state.link \= nil andthen Comp.state.click then
				  {System.show beginmotion}
				  {Comp.state.link send(actions_in moveEnd(x:X-Comp.state.x y:Y-Comp.state.y) _)}
				  Comp.state.x := X
				  Comp.state.y := Y
				  {System.show endmotion}
			       else
				  {System.show Comp.state.link}
				  {System.show Comp.state.click}
			       end
			    end)
		      )
		   outPorts(line)
		   state(link:nil bPoint:nil x:0 y:0 click:false)
		   )
      }
   end
end