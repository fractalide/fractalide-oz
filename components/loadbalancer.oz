functor
export
   Component
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
   Component = comp(
		  description:"loadbalancer"
		  inPorts(input)
		  outArrayPorts(output)
		  procedure(FunPort1)
		  state(cpt:0)
		  )
end
      
   