functor
import
   Simple at './simpleui.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      Catch = fun {$ IP BufPut Out NVar State Options}
		 case {Label IP}
		 of create_ui then R H in
		    R = some(create_ui({Record.adjoin IP td(handle:H)}
				      )
			    )
		    State.handle := H
		    R
		 else
		    some(IP)
		 end
	      end
   in
      {Simple.newSpec Name Catch}
   end
end