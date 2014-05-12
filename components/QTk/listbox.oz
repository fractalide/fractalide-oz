functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/listbox'
		   inPorts('in' list)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				if {Ins.list.size} > 0 then {ListProc Ins.list Out Comp} end
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP listbox(handle:H
				       action:proc{$} F S E in
						 F = {H get(firstselection:$)}
						 S = {H get(selection:$)}
						 E = {List.nth {H get($)} F}
						 {QTkHelper.sendOut Out select(firstselection:F selection:S element:E)}
					      end
				      )}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	  {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{ListProc In Out Comp} IP in
      IP = {In.get}
      {QTkHelper.manageIP set(IP) Out Comp}
   end
end