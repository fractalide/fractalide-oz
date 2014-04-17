functor
import
   Comp at '../../../lib/component.ozf'
   SubComp at '../../../lib/subcomponent.ozf'
   System
export
   new: CompNewGen
define
   fun {OutPortWrapper Out}
      proc{$ send(N Msg Ack)}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   Inter = 5.0
   Height = 10.0
   Width = 75.0
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createComp'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of add then C X X2 Y in
				  C = {SubComp.new IP.1 "editor/component/port" "/home/denis/fractalide/fractallang/components/editor/component/port.fbp"}
				  {Wait C}
				  {C bind(ui_out {OutPortWrapper Out} widget_out)}
				  % Little rectangle will resend info to the manager
				  {C bind(actions_out {OutPortWrapper Out} actions_out)}
				  {C start}
				  % Move already existing port up
				  for Port in Comp.state.list do Ack in
				     {Port send(actions_in move(0.0 ~((Height/2.0)+(Inter/2.0))) Ack)}
				     {Wait Ack}
				  end
				  % Create the begin coordinate
				  X = Comp.state.x
				  X2 = if Comp.options.side == left then X+Width else X-Width end
				  Y = Comp.state.y + ~(Height/2.0) + ({Int.toFloat {List.length Comp.state.list}}*((Height/2.0)+(Inter/2.0)))
				  {C send(ui_in create(X Y X2 Y+Height fill:white) _)}
				  Comp.state.list := C | Comp.state.list
			       [] move then DX DY in
				  {System.show managerportpanel#IP}
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
				 if Comp.state.x == ~1 andthen Comp.state.y == ~1 then
				    Comp.state.x := Comp.options.x
				    Comp.state.y := Comp.options.y
				 end
			      end)
		   outPorts(widget_out actions_out)
		   options(side:_ x:_ y:_ )
		   state(list:nil x:~1 y:~1)
						     
		   )
      }
   end
end