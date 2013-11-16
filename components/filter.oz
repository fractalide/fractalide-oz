functor
import
   Comp at '../lib/component.ozf'
export
   new:New
define
   fun{New}
      {Comp.new
       [i1 i2]
       [even odd]
       proc {$ In Out}
	  Res in
	  Res = In.i1 * In.i2
	  if Res mod 2 == 0 then
	     {Send Out.even Res}
	  else
	     {Send Out.odd Res}
	  end
       end}
   end
end