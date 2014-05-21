functor
import
   Comp at '../../../lib/component.ozf'
   Compiler
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/linkEdit/display'
		   inPorts(input)
		   outPorts(disp output options name type)
		   state(comp:nil name:nil)
		   procedure(proc{$ Ins Out Comp} {InputProc Ins.input Out Comp} end)
		   )
      }
   end
   proc{InputProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of displayComp then Ack S in
	 {Out.disp display}
	 if Comp.state.comp \= nil then A in
	    {Comp.state.comp send('in' closeObj A)}
	    {Wait A}
	 end
	 Comp.state.comp := IP.1
	 {IP.1 send('in' displayObj Ack)}
	 S = {(IP.2) getState($)}
	 {Out.options state(S)}
	 {Wait Ack}
	 {Out.name set(text:S.name)}
	 {Out.type set(text:S.type)}
	 Comp.state.name := S.name
      [] start then Ack in
	 {Comp.state.comp send('in' start Ack)}
	 {Wait Ack}
      [] stop then Ack in
	 {Comp.state.comp send('in' stop Ack)}
	 {Wait Ack}
      [] newComp then Ack S NS in
	 S = {(IP.1) getState($)}
	 NS = {Record.adjoinAt S name Comp.state.name}
	 {(IP.1) setState(NS)}
	 {Comp.state.comp send('in' IP Ack)}
	 {Wait Ack}
	 {Out.options state(S)}
	 {Out.name set(text:NS.name)}
	 {Out.type set(text:NS.type)}
      [] displayGraph then
	 if Comp.state.comp \= nil then Ack in 
	    {Comp.state.comp send('in' closeObj Ack)}
	    {Wait Ack}
	 end
	 Comp.state.comp := nil
      [] delete then Ack in
	 {Comp.state.comp send('in' delete Ack)}
	 {Wait Ack}
	 Comp.state.comp := nil
	 {Out.output displayGraph}
      [] change then L V Ack S in
	 L = {VirtualString.toAtom IP.label}
	 V = {Compiler.virtualStringToValue IP.value}
	 {Comp.state.comp send('in' options(L:V) Ack)}
	 {Wait Ack}
	 S = {Comp.state.comp getState($)}
	 {Wait S}
      [] textChanged then Ack in
	 Comp.state.name := IP.1
	 {Comp.state.comp send('in' nameChange(IP.1) Ack)}
	 {Wait Ack}
      end
   end
end