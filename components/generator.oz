functor
import
   Comp at '../lib/component.ozf'
export
   new: New
define
   proc {Proc Out Comp}
      proc {Rec}
	 {Delay 1000}
	 {Out.output Comp.state.cpt}
	 Comp.state.cpt := Comp.state.cpt + 1
	 {Rec}
      end
   in
      {Rec}
   end
   fun {New Name} Generator in
      Generator = {Comp.new component(
			       name: Name type:generator
			       outPorts(output)
			       procedures(Proc)
			       state(cpt:1)
			       )
		  }
      Generator
   end
end
     