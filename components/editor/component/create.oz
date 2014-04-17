functor
import
   Comp at '../../../lib/component.ozf'
   System
export
   new: CompNewGen
define
   fun {CompNewGen Name} Width Height in
      Width = 100.0
      Height = 50.0
      {Comp.new comp(
		   name:Name type:'components/editor/component/create'
		   inPorts(
		      input(proc{$ In Out Comp} Rec RecF X X2 Y Y2 W2 H2 in
			       W2 = Width/2.0
			       H2 = Height/2.0
			       Rec = {In.get}
			       %{System.show create#RecF.x#RecF.y}
			       X = Rec.x - W2
			       Y = Rec.y - H2
			       X2 = X+Width
			       Y2 = Y+Height
			       {Out.rect start(X Y X2 Y2 width:3 fill:white)}
			       {Out.inPorts opt(side:right x:Rec.x-H2-30.0 y:Rec.y)}
			       {Out.outPorts opt(side:left x:Rec.x+H2+30.0 y:Rec.y)}
			       %Name
			       {Out.name create(init:"initName")}
			       {Out.pos start(Rec.x Rec.y)}
			    end)
		      )
		   outPorts(rect inPorts outPorts name pos)
		   )
      }
   end
end