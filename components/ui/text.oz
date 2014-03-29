functor
import
   Simple at './simpleui.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      Proc = proc{$ Buf Out NVar State Options} Event in
		Event = {Buf.get}
		case {Label Event}
		of set then
		   {State.handle set(Event.1)}
		[] get then Rec in
		   Rec = {Record.make Event.1 [1]}
		   Rec.1 = {State.handle get($)}
		   {Simple.sendOut Out Rec}
		else
		   {Simple.sendOut Out Event}
		end
	     end
      
      UI =  ui(procedure:proc {$ Point Out Options State} H in
			    {Out.ui_create_out {Record.adjoin Options text(handle:H)}}
			    State.handle := H
			 end
	       init:true)
   in
      {Simple.newSpec Name spec(ui:UI procedure:Proc)}
   end
end