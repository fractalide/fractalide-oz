functor
import
   Simple at './simpleui.ozf'
   Qtk at 'x-oz://system/wp/QTk.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      Proc = proc{$ Buf Out NVar State Options} Msg in
		Msg = {Buf.get}
		case Msg
		of close then
		   {State.topLevel close}
		else
		   {Simple.sendOut Out {Buf.get}}
		end
	     end
      UI = ui(procedure:proc {$ Msg Out Options State}
			   State.topLevel := {Qtk.build Msg}
			   {State.topLevel show}
			   {State.topLevel {Record.adjoin Options set}}
			end
	     )
   in
      {Simple.newSpec Name spec(ui:UI procedure:Proc)}
   end
end