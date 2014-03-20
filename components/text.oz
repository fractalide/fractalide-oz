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
		      ui_event: proc{$ Buf Out NVar State Options} Event in
				   Event = {Buf.get}
				   case {Label Event}
				   of set then
				      {State.handle set(Event.1)}
				   [] get then Rec in
				      Rec = {Record.make Event.1 [1]}
				      Rec.1 = {State.handle get($)}
				      {SendOut Out Rec}
				   else
				      {SendOut Out Event}
				   end
				end
		      )
		   outPorts(events_out_default ui_create_out)
		   outArrayPorts(events_out)
		   options()
		   ui(procedure:proc {$ Point Out Options State} H in
				   {Out.ui_create_out {Record.adjoin Options text(handle:H)}}
				   State.handle := H
				end
		      init:true)
		   )}
   end
end