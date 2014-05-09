functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
define
   proc {FunPort1 Bufs Out Comp}
      Num IP P
   in
      IP = {Bufs.input.get}
      Num = (Comp.state.cpt mod {Record.width Out.output}) + 1
      P = {List.nth {Record.toList Out.output} Num}
      {P IP}
      Comp.state.cpt := Num
   end
   fun {CompNew Name}
      {Comp.new comp(
		   name:Name type:loadbalancer
		   inPorts(input)
		   outArrayPorts(output)
		   procedure(FunPort1)
		   state(cpt:0)
		   )
      }
   end
end
      
   