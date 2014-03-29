/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Simple at './simpleui.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      UI = ui(procedure:proc {$ Point Out Options State}
			   {Out.ui_create_out
			    {Record.adjoin Options
			     button(text:Options.text
				    action: proc{$} {Send Point send(events button_clicked(Options.text) _)} end
				   )
			    }}
			end
	      init:true)
   in
      {Simple.newSpec Name spec(ui:UI)}
   end
end