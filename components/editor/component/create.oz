functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} Width Height in
      % Width and Height of a component
      Width = 120.0
      Height = 50.0
      {Comp.new comp(
		   name:Name type:'components/editor/component/create'
		   inPorts(
		      input(proc{$ In Out Comp} Rec X X2 Y Y2 W2 H2 in
			       % Compute the initial position
			       W2 = Width/2.0
			       H2 = Height/2.0
			       Rec = {In.get}
			       X = Rec.x - W2
			       Y = Rec.y - H2
			       X2 = X+Width
			       Y2 = Y+Height
			       % Create the main box
			       {Out.rect start(X Y X2 Y2 width:3 fill:white)}
			       % Create the port panels
			       {Out.inPorts opt(side:right x:Rec.x-H2-40.0 y:Rec.y)}
			       {Out.outPorts opt(side:left x:Rec.x+H2+40.0 y:Rec.y)}
			       % Create the name
			       {Out.name create(init:{Atom.toString Rec.name})}
			       % Create the "real" comp
			       {Out.comp create(name:{Atom.toString Rec.name})}
			       {Out.pos start(Rec.x Rec.y)}
			    end)
		      )
		   outPorts(rect inPorts outPorts name pos comp)
		   )
      }
   end
end