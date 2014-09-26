functor
import
   QTkHelper
export
   Component
define
   Component = comp(
		  description:"the QTk dropdownlistbox"
		  inPorts('in' list)
		  outPorts(out)
		  outArrayPorts(action)
		  procedure(proc{$ Ins Out Comp}
			       if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
			       if {Ins.list.size} > 0 then {ListProc Ins.list Out Comp} end
			    end)
		  state(handle:_ buffer:nil t:nil)
		  )
   
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 if Comp.state.t \= nil andthen {Thread.state Comp.state.t} \= terminated then {Thread.terminate Comp.state.t} end
	 B = {Record.adjoin IP dropdownlistbox(handle:H
					       action:proc{$} F E in
							 F = {H get(firstselection:$)}
							 E = {List.nth {H get($)} F}
							 {Comp.entryPoint send('in' select(firstselection:F element:E) _)}
						      end
					      )}
	 {Out.out create(B)}
	 thread
	    Comp.state.t := {Thread.this}
	    {Wait H}
	    {QTkHelper.bindEvents H Comp.entryPoint}
	    Comp.state.handle := H
	    {QTkHelper.feedBuffer Out Comp}
	 end
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{ListProc In Out Comp} IP in
      IP = {In.get}
      {QTkHelper.manageIP set(IP) Out Comp}
   end
end