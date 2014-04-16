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
			       case IP
			       of createLink(entryPoint:BPoint x:X y:Y canvas:Canvas) andthen {Not Comp.state.click} then L in
				  L = {SubComp.new test type "/home/denis/fractalide/fractallang/components/editor/link.fbp"}
				  Comp.state.link := L
				  {L bind(ui_out Canvas actions_in)}
				  {L bind(actions_out Canvas actions_in)}
				  {L send(actions_in lower _)}
				  {L start}
				  {L send(ui_in startline(x:X y:Y) _)}
				  Comp.state.bPoint := BPoint
				  Comp.state.click := true
			       [] createLink(entryPoint:EPoint x:_ y:_ canvas:_) andthen Comp.state.click andthen Comp.state.link \= nil andthen Comp.state.bPoint \= nil then
				  {System.show Comp.state.bPoint == EPoint}
				  {Comp.state.bPoint bind(action#moveBegin Comp.state.link actions_in)}
				  {EPoint bind(action#moveEnd Comp.state.link actions_in)}
				  Comp.state.link := nil
				  Comp.state.bPoint := nil
				  Comp.state.click := false
 			       % [] 'ButtonRelease'(button:3 x:_ y:_) andthen Comp.state.click == true then
			       % 	  {Comp.state.link send(actions_in delete _)}
			       % 	  Comp.state.link := nil
			       % 	  Comp.state.bPoint := nil
			       % 	  Comp.state.click := false
			       [] 'Motion'(state:_ x:X y:Y) andthen Comp.state.link \= nil andthen Comp.state.click then
				  {Comp.state.link send(actions_in moveEnd(x:X y:Y) _)}
			       else
				  skip
			       end
			    end)
		      )
		   outPorts(line)
		   state(link:nil bPoint:nil click:false)
		   )
      }
   end
end