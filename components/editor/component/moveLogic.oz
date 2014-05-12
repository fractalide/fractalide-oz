functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/moveLogic"
		   inPorts(input)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} Rec in
			       Rec = {Ins.input.get}
			       {Out.output moveBegin(x:Rec.1 y:Rec.2)}
			       {Out.output moveEnd(x:Rec.1 y:Rec.2)}
			    end)
		   )
      }
   end
end