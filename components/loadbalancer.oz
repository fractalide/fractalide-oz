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
   fun {CompNew Name}
      {Comp.new comp(
		   name:Name type:loadbalancer
		   inPorts(input: FunPort1)
		   outPorts(output)
		   state(cpt:0)
		   )
      }
   end
end
      
   