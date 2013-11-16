functor
import
   Comp at '../lib/component.ozf'
   Browser
export
   new:New
define
   fun{New}
      {Comp.new
       [input]
       nil
       proc {$ In Out}
	  {Browser.browse In.input#' is odd'}
       end}
   end
end