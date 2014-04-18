functor
import
   Comp at '../../../lib/component.ozf'
   SubComp at '../../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   % Side filter event from input port panel or output port panel
   fun {OutPortWrapper Out Side}
      proc{$ send(N Msg Ack)}
	 if {Label Msg} == createLink then
	    {Out.N {Record.adjoin r(side:Side) Msg}}
	 else
	    {Out.N Msg}
	 end
	 Ack = ack
      end
   end
   % Size of a port
   Inter = 5.0
   Height = 15.0
   Width = 75.0
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createComp'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of add then C X X2 Y in
				  C = {SubComp.new IP.1 "editor/component/port" "./components/editor/component/port.fbp"}
				  {Wait C}
				  {C bind(ui_out {OutPortWrapper Out Comp.options.side} widget_out)}
				  {C bind(actions_out {OutPortWrapper Out Comp.options.side} actions_out)}
				  {C start}
				  % Move already existing port up
				  for Port in Comp.state.list do Ack in
				     {Port send(actions_in move(0.0 ~((Height/2.0)+(Inter/2.0))) Ack)}
				     {Wait Ack}
				  end
				  % Create the begin coordinate
				  X = Comp.state.x
				  X2 = if Comp.options.side == left then X+Width else X-Width end
				  % Y = y + (-H/2) + (n * (H/2 + I/2))
				  Y = Comp.state.y + ~(Height/2.0) + ({Int.toFloat {List.length Comp.state.list}}*((Height/2.0)+(Inter/2.0)))
				  {C send(ui_in create(X Y X2 Y+Height fill:white) _)}
				  Comp.state.list := C | Comp.state.list
			       [] move then DX DY in
				  DX = {Int.toFloat IP.1}
				  DY = {Int.toFloat IP.2}
				  for Port in Comp.state.list do Ack in
				     {Port send(actions_in move(DX DY) Ack)}
				     {Wait Ack}
				  end
				  Comp.state.x := Comp.state.x + DX
				  Comp.state.y := Comp.state.y + DY
			       else skip
			       end
			    end)
		      )
		   procedures(proc{$ Out Comp}
				 if {Not {IsDet Comp.state.x}} orelse {Not {IsDet Comp.state.y}} then
				    Comp.state.x := Comp.options.x
				    Comp.state.y := Comp.options.y
				 end
			      end)
		   outPorts(widget_out actions_out)
		   options(side:_ x:_ y:_ )
		   state(list:nil x:_ y:_)
						     
		   )
      }
   end
end