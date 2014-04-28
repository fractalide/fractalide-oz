functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/mouseLogic'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of 'ButtonPress' andthen Comp.state.outComp then X Y New in
				  Comp.state.drag := true
				  X = {Comp.options.canvas canvasx(IP.x $)}
				  Y = {Comp.options.canvas canvasy(IP.y $)}
				  New = {Record.adjoinAt {Record.adjoinAt IP x X} y Y}
				  {Out.dclick New}
				  {Out.drag IP}
			       [] 'ButtonRelease' andthen Comp.state.drag andthen Comp.state.outComp then
				  Comp.state.drag := false
				  {Out.drag IP}
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
			       [] inComponent then
				  Comp.state.outComp := false
				  Comp.state.drag := false
			       [] outComponent then
				  Comp.state.outComp := true
			       else
				  skip
			       end
			    end)
		      )
		   outPorts(dclick drag link)
		   options(canvas:_)
		   state(outComp:true drag:false link:false)
		   )
      }
   end
end