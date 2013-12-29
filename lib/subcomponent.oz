functor
import
   GraphModule at './graph.ozf'
export
   new: NewSubComponent
define
   fun {NewSubComponent Graph}
      Stream Point = {NewPort Stream}
      thread
	 {FoldL Stream
	  fun {$ State Msg}
	     case Msg
	     of getState(?Resp) then Resp = State State
	     [] send(InPort Msg Ack) then
		{State.inPorts.InPort.1 send(State.inPorts.InPort.2 Msg Ack)}
		State
	     [] bind(OutPort Comp Name) then
		{State.outPorts.OutPort.1 bind(State.outPorts.OutPort.2 Comp Name)}
		State
	     [] unbound(OutPort N) then
		{State.outPorts.OutPort.1 unbound(State.outPorts.OutPort.2 N)}
		State
	     [] start then
		{GraphModule.start State.graph}
		State
	     [] stop then
		{GraphModule.stop State.graph}
		State
	     %% Help methods
	     [] renameInPort(OName NName) then 
		{Record.adjoinAt State inPorts {Rename State.inPorts OName NName}}
	     [] renameOutPort(OName NName) then
		{Record.adjoinAt State outPorts {Rename State.outPorts OName NName}}
	     end
	  end
	  {Init Graph}
	  _
	 }
      end
   in
      proc {$ Msg} {Send Point Msg} end
   end
   fun {Init G}
      In#Out = {GraphModule.getUnBoundPorts G}
      InPorts = {FoldL In
		 fun {$ Acc Point#CompName#PortName} NName in
		    case PortName
		    of RealName#Number then
		       NName = {VirtualString.toAtom {Atom.toString CompName}#"_"#{Atom.toString RealName}#"_"#{Int.toString Number}}
		    else
		       NName = {VirtualString.toAtom {Atom.toString CompName}#"_"#{Atom.toString PortName}}
		    end
		    {AdjoinAt Acc NName Point#PortName}
		 end
		 inPorts
		}
      OutPorts = {FoldL Out
		  fun {$ Acc Point#CompName#PortName} NName in
		     NName = {VirtualString.toAtom {Atom.toString CompName}#"_"#{Atom.toString PortName}}
		     {AdjoinAt Acc NName Point#PortName}
		  end
		  outPorts
		 }
   in
      subcomponent(inPorts:InPorts outPorts:OutPorts graph:G)
   end
   fun {Rename Rec OName NName} Temp in
      Temp = {Record.adjoinAt Rec NName Rec.OName}
      {Record.subtract Temp OName}
   end
end
      