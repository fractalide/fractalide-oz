functor
import
   Browser
   Comp at '../lib/component.ozf'
export
   new: New
define
   proc {Proc Out NVar State Options}
      proc {Rec}
	 {Delay 1000}
	 {Out.output State.cpt}
	 State.cpt := State.cpt + 1
	 {Rec}
      end
   in
      {Browser.browse starting}
      {Rec}
   end
   fun {New} Generator in
      Generator = {Comp.new component(
			       outPorts(output)
			       procedures(Proc)
			       state(cpt:1)
			       )
		  }
      Generator
   end
end
     