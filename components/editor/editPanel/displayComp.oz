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
			       of displayComp then
				  {Out.disp display}
				  Comp.state.link := IP.1
			       [] start then Ack in
				  {Comp.state.link send(actions_in start Ack)}
				  {Wait Ack}
			       [] stop then Ack in
			       {Comp.state.link send(actions_in stop Ack)}
				  {Wait Ack}
			       [] newComp then Ack in
				  {Comp.state.link send(actions_in IP Ack)}
				  {Wait Ack}
			       end
			    end)
		      )
		   outPorts(disp output)
		   state(link:nil)
		   )
      }
   end
end