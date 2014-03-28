/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.events_out}} then
	 {OutPorts.events_out.{Label Event} Event}
      else
	 {OutPorts.events_out_default Event}
      end
   end
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:button
		   inPorts(
		      events: proc{$ Buf Out NVar State Options}
				   {SendOut Out {Buf.get}}
				end
		      )
		   outPorts(events_out_default ui_create_out)
		   outArrayPorts(events_out)
		   options(text:default)
		   ui(procedure:proc {$ Point Out Options State}
				   {Out.ui_create_out
				    {Record.adjoin Options
				     button(text:Options.text
					    action: proc{$} {Send Point send(events button_clicked(Options.text) _)} end
					   )
				    }}
				end
		      init:true)
		   )}
   end
end