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
	 elseif N == actions_out then
	    {SendOut Out Msg}
	 else
	    {Out.N Msg}
	 end
	 Ack = ack
      end
   end
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.actions_out Event}
      end
   end
   % Size of a port
   Inter = 5.0
   Height = 15.0
   Width = 75.0
   % A forall for all port and arrayport
   proc {ForAll2 Rec Proc}
      {Record.forAll Rec
       proc{$ R}
	  if {Not {Record.is R}} then
	     {Proc R}
	  else
	     {Record.forAll R
	      proc{$ P} {Proc P} end
	     }
	  end
       end
      }
   end
   % Compute the size of the ports record (with the arrayport)
   fun {SizePorts Rec}
      {Record.foldL Rec
       fun {$ Acc Port}
	  if {Not {Record.is Port}} then Acc+1
	  else
	     Acc + {Record.width Port}
	  end
       end
       0}
   end
   % Compute the size of the portpanel : the borders
   fun {ComputeBorder Comp}
      if Comp.state.show then W in
	 W = if {Record.width Comp.state.ports} > 0 then Width+10.0 else 0.0 end
	 if Comp.options.side == left then
	    left(width:W height:({Int.toFloat {SizePorts Comp.state.ports}}*(Height+Inter))-Inter)
	 else
	    right(width:W height:({Int.toFloat {SizePorts Comp.state.ports}}*(Height+Inter))-Inter)
	 end
      else
	 if Comp.options.side == left then
	    left(width:0.0 height:0.0)
	 else
	    right(width:0.0 height:0.0)
	 end
      end
   end
   proc {Hide Out Comp}
      Comp.state.show := false
      {ForAll2 Comp.state.ports
       proc{$ Port} Ack Ack2 in
	  if Comp.options.side == left then
	     {Port send(actions_in moveBeginPos(x:Comp.state.x y:Comp.state.y) Ack)}
	  else
	     {Port send(actions_in moveEndPos(x:Comp.state.x y:Comp.state.y) Ack)}
	  end
	  {Wait Ack}
	  {Port send(actions_in set(state:hidden) Ack2)}
	  {Wait Ack2}
       end
      }
      {Out.border {ComputeBorder Comp}}
   end
   proc {Show Out Comp} InitPoint N I in
      Comp.state.show := true
      % Y = N*(H/2+I/2) + I(H+I)
      N = {Int.toFloat {SizePorts Comp.state.ports}-1}
      InitPoint = Comp.state.y - N * (Height/2.0 + Inter/2.0)
      I = {NewCell 0.0}
      {Record.forAll Comp.state.ports
       proc{$ Port} Ack Ack2 Y in 
	  Y = InitPoint + @I * (Height + Inter)
	  I := @I+1.0
	  if {Not {Record.is Port}} then % It's a simple port
	     if Comp.options.side == left then
		{Port send(actions_in moveBeginPos(x:Comp.state.x+Width y:Y) Ack)}
	     else
		{Port send(actions_in moveEndPos(x:Comp.state.x-Width y:Y) Ack)}
	     end
	     {Port send(actions_in set(state:normal) Ack2)}
	     {Wait Ack2}
	  else Ack3 in% It's an array port
	     {Record.forAll {Record.subtract Port arrayPort}
	      proc{$ P} Y2 in
		 Y2 = InitPoint + @I * (Height + Inter)
		 I := @I + 1.0
		 if Comp.options.side == left then
		    {P send(actions_in moveBeginPos(x:Comp.state.x+Width+10.0 y:Y2) Ack)}
		 else
		    {P send(actions_in moveEndPos(x:Comp.state.x-Width-10.0 y:Y2) Ack)}
		 end
		 {P send(actions_in set(state:normal) Ack2)}
		 {Wait Ack2}
	      end}
	     {Port.arrayPort send(actions_in set(state:normal) Ack3)}
	     {Wait Ack3}
	  end
       end
      }
      {Out.border {ComputeBorder Comp}}
   end
   proc {Draw Out Comp} InitPoint I in
      InitPoint = Comp.state.y + ~(Height/2.0) - {Int.toFloat ({SizePorts Comp.state.ports}-1)} * (Height/2.0 + Inter/2.0)
      I = {NewCell 0.0}
      {Record.forAll Comp.state.ports
       proc{$ Port} X Y in
	  X = if Comp.options.side == left then Comp.state.x else Comp.state.x-Width end
	  if {Not {Record.is Port}} then Ack Ack2 in
	     % Reposition
	     Y = InitPoint + @I * (Height+Inter)
	     {Port send(actions_in setCoords(X Y X+Width Y+Height) Ack)}
	     {Wait Ack}
	     I := @I + 1.0
	     % Reset the state
	     if Comp.state.show then
		{Port send(actions_in set(state:normal) Ack2)}
	     else
		{Port send(actions_in set(state:hidden) Ack2)}
	     end
	     {Wait Ack2}
	  else Ack Ack2 X2 in
	     % The name of the array port
	     Y = InitPoint + @I * (Height+Inter)
	     {Port.arrayPort send(actions_in setCoords(X Y X+Width Y+Height) Ack)}
	     {Wait Ack}
	     if Comp.state.show then
		{Port.arrayPort send(actions_in set(state:normal) Ack2)}
	     else
		{Port.arrayPort send(actions_in set(state:hidden) Ack2)}
	     end
	     {Wait Ack2}
	     % The sub-ports 
	     I := @I + 1.0
	     X2 = if Comp.options.side == left then X+10.0 else X-10.0 end
	     {Record.forAll {Record.subtract Port arrayPort}
	      proc{$ P} Y2 Ack Ack2 in
		 Y2 = InitPoint + @I * (Height+Inter)
		 {P send(actions_in setCoords(X2 Y2 X2+Width Y2+Height) Ack)}
		 {Wait Ack}
		 I := @I + 1.0


		 if Comp.state.show then
		    {P send(actions_in set(state:normal) Ack2)}
		 else
		    {P send(actions_in set(state:hidden) Ack2)}
		 end
		 {Wait Ack2}
	      end}
	  end
       end}
      {Out.border {ComputeBorder Comp}}
   end
   fun {CompNewGen Name} A in
      A = {Comp.new comp(
		       name:Name type:'components/editor/createComp'
		       inPorts(
			  input(proc{$ In Out Comp} IP in
				   IP = {In.get}
				   case {Label IP}
				   of add then C N in % It's a normal port
				  % Create the new port
				      C = {SubComp.new IP.1 "editor/component/port" "./components/editor/component/port.fbp"}
				      {Wait C}
				      {C bind(ui_out {OutPortWrapper Out Comp.options.side} widget_out)}
				      {C bind(actions_out {OutPortWrapper Out Comp.options.side} actions_out)}
				      {C bind('ERROR' {OutPortWrapper Out Comp.options.side} 'ERROR')}
				      {C start}
				      
				      {C send(ui_in create(0.0 0.0 0.0 0.0 fill:white name:IP.1 state:hidden) _)}
				  % Add it in the record
				      N = {Record.width Comp.state.ports}
				      Comp.state.ports := {Record.adjoinAt Comp.state.ports N+1 C}
				      {Draw Out Comp}
				   [] addArrayPort then C in % It's an array port
				  % Create the new port
				      C = {SubComp.new IP.1 "editor/component/port" "./components/editor/component/portArray.fbp"}
				      {Wait C}
				      {C bind(ui_out {OutPortWrapper Out Comp.options.side} widget_out)}
				      {C bind(actions_out {OutPortWrapper Out Comp.options.side} actions_out)}
				      {C bind('ERROR' {OutPortWrapper Out Comp.options.side} 'ERROR')}
				      {C start}
				      
				      {C send(ui_in create(0.0 0.0 0.0 0.0 outline:red fill:white name:IP.1 state:hidden) _)}
				  % Add it in the record
				      Comp.state.ports := {Record.adjoinAt Comp.state.ports {VirtualString.toAtom IP.1} array(arrayPort:C)}
				      {Draw Out Comp}
				   [] addinArrayPort then C NAP in
				  % Create the new port
				      C = {SubComp.new IP.2 "editor/component/port" "./components/editor/component/port.fbp"}
				      {Wait C}
				      {C bind(ui_out {OutPortWrapper Out Comp.options.side} widget_out)}
				      {C bind(actions_out Comp.state.ports.(IP.1).arrayPort actions_in)}
				      {C bind('ERROR' {OutPortWrapper Out Comp.options.side} 'ERROR')}
				      {C start}
				      
				      {C send(ui_in create(0.0 0.0 0.0 0.0 fill:white name:IP.2 state:hidden) _)}
				  % Add it in the record
				      NAP = {Record.adjoinAt Comp.state.ports.(IP.1) {VirtualString.toAtom IP.2} C}
				      Comp.state.ports := {Record.adjoinAt Comp.state.ports (IP.1) NAP}
				      
				      {Draw Out Comp}
				      % Send to the component manager, if it's an input array port
				      if Comp.options.side == right then
					 {Out.border addinArrayPort(IP.1 {VirtualString.toAtom IP.2})}
				      end
				   [] move then DX DY in
				      DX = {Int.toFloat IP.1}
				      DY = {Int.toFloat IP.2}
				      {ForAll2 Comp.state.ports
				       proc{$ Port} Ack in
					  {Port send(actions_in move(DX DY) Ack)}
					  {Wait Ack}
				       end
				      }
				      Comp.state.x := Comp.state.x + DX
				      Comp.state.y := Comp.state.y + DY
				   [] openPorts then
				      {Show Out Comp}
				   [] closePorts then
				      {Hide Out Comp}
				   [] delete then
				      {ForAll2 Comp.state.ports
				       proc{$ Port} 
					  {Port send(actions_in delete _)}
				       end
				      }
				      Comp.state.ports := ports()
				   else
				      skip
				   end
				end)
			  )
		       procedures(proc{$ Out Comp}
				     if {Not {IsDet Comp.state.x}} orelse {Not {IsDet Comp.state.y}} then
					Comp.state.x := Comp.options.x
					Comp.state.y := Comp.options.y
				     end
				  end)
		       outPorts(widget_out actions_out border)
		       outArrayPorts(action)
		       options(side:_ x:_ y:_ )
		       state(ports:ports x:_ y:_ show:false)
						     
		       )
	  }
      {A bind(action#addinArrayPort A input)}
      A
   end
end