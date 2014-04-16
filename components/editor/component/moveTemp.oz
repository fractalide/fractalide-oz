functor
import
   Comp at '../lib/component.ozf'
   Milli at 'x-oz://boot/Time'
export
   new: CompNew
   newArgs: CompNewArgs
define
   fun {CompNewArgs Name Args}
      {Comp.new comp(name:Name type:timeFrame
		     inPorts(input(proc{$ In Out Comp} IP T in
				      IP = {In.get}
				      T = {Milli.getReferenceTime}
				      if T - Comp.state.last > 50 then
					 Comp.state.last := T
					 {Out.output IP}
				      else
					 Comp.state.x := Comp.state.x + IP.x
					 Comp.state.y := Comp.state.y + IP.y
				      end
				   end)
			    )
		     outPorts(output)
		     state(last:0 x:0 y:0)
		    )
      }
   end
   fun {CompNew Name}
      {CompNewArgs Name r()}
   end
end