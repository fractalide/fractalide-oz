functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
define
   proc {FunPort1 Buf Out Comp}
      Num
   in
      Num = (Comp.state.cpt mod {Record.width Out.output}) + 1
      {Out.output.Num {Buf.get}}
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
      
   