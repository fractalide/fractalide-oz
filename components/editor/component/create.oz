functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/create'
		   inPorts(
		      input(proc{$ In Out Comp} Rec in
			       Rec = {In.get}
			       {Out.rect start(Rec.x Rec.y Rec.x+50 Rec.y+50 fill:black)}
			    end)
		      )
		   outPorts(rect)
		   )
      }
   end
end