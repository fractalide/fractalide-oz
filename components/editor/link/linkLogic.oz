functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/linkLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of outComp then
				  
				  Comp.state.outComp := IP.comp
				  Comp.state.outPortName := IP.name
				  Comp.state.bPoint := IP.bPoint
				  Comp.state.subComp := IP.subComp



				  {Comp.state.bPoint bind(action#moveBegin Comp.state.subComp actions_in)}
				  {Comp.state.bPoint bind(action#moveBeginPos Comp.state.subComp actions_in)}
				  {Comp.state.bPoint bind(action#delete Comp.state.subComp actions_in)}

			       [] inComp then
				  Comp.state.inComp := IP.comp
				  Comp.state.inPortName := IP.name
				  Comp.state.ePoint := IP.ePoint
				  % bind for the line
				  
				  {IP.ePoint bind(action#moveEnd Comp.state.subComp actions_in)}
				  {IP.ePoint bind(action#moveEndPos Comp.state.subComp actions_in)}
				  {IP.ePoint bind(action#delete Comp.state.subComp actions_in)}
				  
				  {Comp.state.outComp bind(Comp.state.outPortName IP.comp IP.name)}
			       [] delete then
				  % unbound for the line
				  {Comp.state.bPoint unBound(action#moveBegin Comp.state.subComp)}
				  {Comp.state.ePoint unBound(action#moveEnd Comp.state.subComp)}
				  % "real" comp
				  {Comp.state.outComp unBound(Comp.state.outPortName Comp.state.inComp)}
			       [] open then Ack Ack2 in
				  {Comp.state.bPoint send(actions_in openPorts Ack)}
				  {Wait Ack}
				  {Comp.state.ePoint send(actions_in openPorts Ack2)}
				  {Wait Ack2}
			       [] close andthen {HasFeature IP comp} then Ack Ack2 in
				  {Comp.state.bPoint send(actions_in closePorts(comp:IP.comp) Ack)}
				  {Wait Ack}
				  {Comp.state.ePoint send(actions_in closePorts(comp:IP.comp) Ack2)}
				  {Wait Ack2}
			       [] close then Ack Ack2 in
				  {Comp.state.bPoint send(actions_in closePorts Ack)}
				  {Wait Ack}
				  {Comp.state.ePoint send(actions_in closePorts Ack2)}
				  {Wait Ack2}
			       end
			    end)
		      )
		   state(outComp:nil outPortName:nil
			 inComp:nil inPortName:nil
			 bPoint:nil ePoint:nil
			 subComp:nil)
		   )
      }
   end
end