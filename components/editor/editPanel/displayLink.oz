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
			       of displayLink then
				  {Out.disp display}
				  Comp.state.link := IP.1
			       [] delete then Ack in
				  {Comp.state.link send(actions_in delete Ack)}
				  {Wait Ack}
				  Comp.state.link := nil
				  {Out.output displayGraph}
			       [] displayGraph then
				  Comp.state.link := nil
			       end
			    end)
		      )
		   outPorts(disp output)
		   state(link:nil)
		   )
      }
   end
end