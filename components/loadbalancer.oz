functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
define
   proc {FunPort1 IP Out NVar State Options}
      Num 
   in
      Num = (State.cpt mod {Record.width Out.output}) + 1
      {Out.output.Num IP}
      State.cpt := Num
   end
   fun {CompNew}
      {Comp.new comp(
		   inPorts(
		      port(name:input
			   procedure: FunPort1)
		      )
		   outPorts(output:arrayPort)
		   state(cpt:0)
		   )
      }
   end
end
      
   