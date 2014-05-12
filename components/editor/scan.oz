functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/scan'
		   inPorts(input)
		   outPorts(canvas)
		   procedure(proc{$ Ins Out Comp} IP in
			       IP = {Ins.input.get}
			       case {Label IP}
			       of 'ButtonPress' andthen IP.button == 1 then
				  {Out.canvas scan(mark IP.x IP.y)}
				  Comp.state.click := true
			       [] 'ButtonRelease' andthen IP.button == 1 then
				  Comp.state.click := false
			       [] 'Motion' andthen Comp.state.click then
				  {Out.canvas scan(dragto IP.x IP.y 1)}
				  {Out.canvas scan(mark IP.x IP.y)}
			       else
				  skip
			       end
			    end)
		   state(click:false)
		   )
      }
   end
end