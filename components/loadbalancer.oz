functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
define
   proc {FunPort1 Buf Out Comp}
      Num IP P
   in
      IP = {Buf.get}
      Num = (Comp.state.cpt mod {Record.width Out.output}) + 1
      P = {List.nth {Record.toList Out.output} Num}
      {P IP}
      Comp.state.cpt := Num
   end
   fun {CompNew Name}
      {Comp.new comp(
		   name:Name type:loadbalancer
		   inPorts(input(FunPort1))
		   outArrayPorts(output)
		   state(cpt:0)
		   )
      }
   end
end
      
   