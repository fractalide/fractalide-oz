/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
   newSpec: CompNewGen
   sendOut: SendOut
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.events_out}} then
	 {OutPorts.events_out.{Label Event} Event}
      else
	 {OutPorts.events_out_default Event}
      end
   end
   fun {CompNewGen Name Spec}
      UI = ui(procedure:proc {$ Msg Out Options State}
			   {Out.ui_create_out {Record.adjoin Options Msg}}
			end
	     )
      Proc = proc{$ Buf Out NVar State Options}
		{SendOut Out {Buf.get}}
	     end
      Rec = {Record.adjoin spec(ui:UI procedure:Proc) Spec}
   in
      {Comp.new comp(
		   name:Name type:topdown
		   inPorts(
		      events: Rec.procedure
		      )
		   outPorts(events_out_default ui_create_out)
		   outArrayPorts(events_out)
		   options()
		   Rec.ui
		   )}
   end
   fun {CompNewArgs Name}
      {CompNewGen Name spec}
   end
end