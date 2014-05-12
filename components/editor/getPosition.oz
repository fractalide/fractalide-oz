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
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} X Y in
				_ = {Ins.input.get}
				X = {Comp.options.canvas canvasx(100 $)}
				Y = {Comp.options.canvas canvasy(50 $)}
				{Out.output createComp(button:1 x:X y:Y)}
			     end)
		   options(canvas:_)
		   )
      }
   end
end