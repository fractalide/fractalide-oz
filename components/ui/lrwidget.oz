functor
import
   Simple at './simpleui.ozf'
   Browser
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      Catch = fun {$ IP BufPut Out NVar State Options}
		 case {Label IP}
		 of create_ui then R H in
		    {Browser.browse lr#IP.1}
		    R = some(create_ui({Record.adjoin IP lr(handle:H)}
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