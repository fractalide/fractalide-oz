functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
define
   proc {FunPort1 Buf Out NVar State Options}
      Num ANum
   in
      Num = (State.cpt mod {Record.width Out.output}) + 1
      ANum = {String.toAtom {Int.toString Num}}
      {Out.output.ANum {Buf.get}}
      State.cpt := Num
   end
   fun {CompNew Name}
      {Comp.new comp(
		   name:Name type:loadbalancer
		   inPorts(input: FunPort1)
		   outArrayPorts(output)
		   state(cpt:0)
		   )
      }
   end
end
      
   