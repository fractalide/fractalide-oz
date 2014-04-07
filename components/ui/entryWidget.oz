functor
import
   Simple at './simpleui.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      Catch = fun{$ Event BufPut Out NVar State Options}
		 case {Label Event}
		 of modify then
		    some(modify({String.toAtom {Options.handle get($)}}))
		 [] get then Rec in
		    Rec = {Record.make Event.1 [1]}
		    Rec.1 = {Options.handle get($)}
		    some(Rec)
		 else
		    some(Event)
		 end
	      end
   in
      {Simple.newSpec Name Catch}
   end
end