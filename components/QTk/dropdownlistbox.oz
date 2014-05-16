functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/dropdownlistbox'
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
	 B = {Record.adjoin IP dropdownlistbox(handle:H
					       action:proc{$} F E in
							 F = {H get(firstselection:$)}
							 E = {List.nth {H get($)} F}
							 {Comp.entryPoint send('in' select(firstselection:F element:E) _)}
						      end
					      )}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Comp.entryPoint}
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