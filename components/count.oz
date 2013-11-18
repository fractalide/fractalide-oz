functor
import
   Comp at '../lib/component.ozf'
export
   new:New
define
   fun{New}
      C in
      C = {Comp.new
       [inp state]
       [out state]
       proc {$ In Out}
	  case In.inp
	  of 'begin' then
	     {Send Out.state 0}
	  [] data(_) then
	     {Send Out.state (In.state)+1}
	  else
	     {Send Out.out In.state}
	     {Send Out.state 0}
	  end
       end}
      {Comp.bind C.outPorts.state C.inPorts.state}
      {Send C.inPorts.state 0}
      C
   end
end