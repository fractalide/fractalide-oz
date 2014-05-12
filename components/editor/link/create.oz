functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/create'
		   inPorts(input)
		   outPorts(line outComp)
		   procedure(proc{$ Ins Out Comp} Rec in
			       Rec = {Ins.input.get}
			       {Out.line create(Rec.x Rec.y Rec.x Rec.y arrow:last width:0)}
			       {Out.line lower}
			       {Out.outComp outComp(comp:Rec.outComp name:Rec.outPortName bPoint:Rec.bPoint subComp:Rec.subComp)}
			    end)
		   )
      }
   end
end