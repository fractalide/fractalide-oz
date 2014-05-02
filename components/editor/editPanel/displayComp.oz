functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/linkEdit/display'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of displayComp then Ack in
				  {Out.disp display}
				  if Comp.state.comp \= nil then A in
				     {Comp.state.comp send(actions_in closePorts A)}
				     {Wait A}
				  end
				  Comp.state.comp := IP.1
				  {IP.1 send(actions_in openPorts Ack)}
				  {Wait Ack}
			       [] start then Ack in
				  {Comp.state.comp send(actions_in start Ack)}
				  {Wait Ack}
			       [] stop then Ack in
				  {Comp.state.comp send(actions_in stop Ack)}
				  {Wait Ack}
			       [] newComp then Ack in
				  {Comp.state.comp send(actions_in IP Ack)}
				  {Wait Ack}
			       [] displayGraph then
				  if Comp.state.comp \= nil then Ack in 
				     {Comp.state.comp send(actions_in closePorts Ack)}
				     {Wait Ack}
				  end
				  Comp.state.comp := nil
			       [] delete then Ack in
				  {Comp.state.comp send(actions_in delete Ack)}
				  {Wait Ack}
				  Comp.state.comp := nil
				  {Out.output displayGraph}
			       end
			    end)
		      )
		   outPorts(disp output)
		   state(comp:nil)
		   )
      }
   end
end