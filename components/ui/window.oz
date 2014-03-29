/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Comp at '../../lib/component.ozf'
   Qtk at 'x-oz://system/wp/QTk.ozf'
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
		   name:Name type:window
		   inPorts(
		      events: proc{$ Buf Out NVar State Options} Msg in
				   Msg = {Buf.get}
				   case Msg
				   of close then
				      {State.topLevel close}
				   else
				      {SendOut Out {Buf.get}}
				   end
				end
		      )
		   outPorts(events_out_default ui_create_out)
		   outArrayPorts(events_out)
		   options()
		   ui(procedure:proc {$ Msg Out Options State}
				   State.topLevel := {Qtk.build Msg}
				   {State.topLevel show}
				   {State.topLevel {Record.adjoin Options set}}
				end
		      )
		   )}
   end
end