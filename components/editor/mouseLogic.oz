functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/mouseLogic'
		   inPorts(input)
		   outPorts(drag link click)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.input.get}
				case {Label IP}
				of 'ButtonPress' andthen Comp.state.outComp then
				   Comp.state.drag := true
				   {Out.drag IP}
				[] 'ButtonRelease' andthen Comp.state.drag andthen Comp.state.outComp then
				   Comp.state.drag := false
				   {Out.drag IP}
				   {Out.click IP}
				[] beginLink then
				   Comp.state.link := true
				[] endLink then
				   Comp.state.link := false
				[] 'Motion' then X Y NewMotion in
				   X = {Comp.options.canvas canvasx(IP.x $)}
				   Y = {Comp.options.canvas canvasy(IP.y $)}
				   NewMotion = {Record.adjoinAt {Record.adjoinAt IP x X} y Y}
				   if Comp.state.link then
				      {Out.link NewMotion}
				   elseif Comp.state.drag andthen Comp.state.outComp then
				      {Out.drag IP}
				   end
				[] inObject then
				   Comp.state.outComp := false
				   Comp.state.drag := false
				[] outObject then
				   Comp.state.outComp := true
				else
				   skip
				end
			     end)
		   options(canvas:_)
		   state(outComp:true drag:false link:false)
		   )
      }
   end
end