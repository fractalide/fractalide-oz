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
		      input
		      )
		   outPorts(disp output)
		   state(link:nil)
		   procedure(proc{$ Ins Out Comp} {InputProc Ins.input Out Comp} end)
		   )
      }
   end
   proc{InputProc In Out Comp} IP Ack in
      IP = {In.get}
      case {Label IP}
      of displayLink then
	 if Comp.state.link \= nil then Ack in
	    {Comp.state.link send('in' close Ack)}
	    {Wait Ack}
	 end
	 {Out.disp display}
	 Comp.state.link := IP.1
	 {IP.1 send('in' open Ack)}
	 {Wait Ack}
      [] delete then Ack Ack2 in
	 {Comp.state.link send('in' close Ack)}
	 {Wait Ack}
	 {Comp.state.link send('in' delete Ack2)}
	 {Wait Ack2}
	 Comp.state.link := nil
	 {Out.output displayGraph}
      [] displayGraph then
	 if Comp.state.link \= nil then Ack in
	    {Comp.state.link send('in' close Ack)}
	    {Wait Ack}
	 end
	 Comp.state.link := nil
      [] displayComp then
	 if Comp.state.link \= nil then Ack in
	    {Comp.state.link send('in' close(comp:IP.1) Ack)}
	    {Wait Ack}
	 end
	 Comp.state.link := nil
      end
   end

end