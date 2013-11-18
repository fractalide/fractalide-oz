functor
import
   Comp at '../lib/component.ozf'
   Browser
export
   new:New
define
   fun{New}
      {Comp.new
       [inp]
       nil
       proc {$ In Out}
	  {Browser.browse In.inp}
       end}
   end
end