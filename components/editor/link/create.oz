functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/create'
		   inPorts(
		      input(proc{$ In Out Comp} Rec in
			       Rec = {In.get}
			       {Out.line start(Rec.x Rec.y Rec.x Rec.y arrow:last width:0)}
			       {Out.line lower}
			       {Out.outComp outComp(comp:Rec.outComp name:Rec.outPortName bPoint:Rec.bPoint subComp:Rec.subComp)}
			    end)
		      )
		   outPorts(line outComp)
		   )
      }
   end
end