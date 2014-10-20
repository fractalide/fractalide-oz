/*
<one line to give the program's name and a brief idea of what it does.>
Copyright (C) 2014 Noware Ltd.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
functor
import
   Fractalide at './fractalide.ozf'
export
   new: NewSubComponent
define
   /*
   A subcomponent is represented with a record like :.
   subcomponent(
      graph:(graph(inLinks:[name#destComp#destPortName name2#destComp2#destPortName2]
		   destComp:node(comp:<P/1> inPortBinded:[...])
		   destComp2:node(comp:<P/1> inPortBinded:[...])
		   outLinks:[name#destComp#destPortName ...]
		   edges:[...]
		  ))
      inPorts:inPorts(
		 a:[<P/1>#a <P/1>#b]
		 b:[ ... ]
		 )
      outPorts:outPorts(
		  o:[<P/1>#out ...]))
   */
   fun {NewSubComponent Name Type Graph}
      TheGraph = {Init Name Type Graph}
      Stream Point = {NewPort Stream}
      thread
	 {FoldL Stream
	  fun {$ State Msg}
	     case Msg
	     of getState(?Resp) then
		Resp = State
		State
	     [] setState(NewState) then
		NewState
	     [] send(InPort#N Msg Ack) then
		try
		   for X in State.inPorts.InPort do
		      {X.1 send(X.2#N Msg Ack)}
		   end
		   State
		catch E then
		   raise cannot_send_array(error:E state:State name:State.name type:State.type) end
		end
	     [] send(InPort Msg Ack) then
		try
		   for X in State.inPorts.InPort do A=_ in
		      {X.1 send(X.2 Msg A)}
		      {Wait A}
		   end
		   Ack = ack
		   State
		catch E then
		   raise cannot_send(error:E state:State name:State.name type:State.type) end
		end
	     [] setParentEntryPoint(ParentEntryPoint) then
		{Record.adjoinAt State parentEntryPoint ParentEntryPoint}
	     [] connect(Port Index) then
		try
		   for X in State.inPorts.Port do
		      {X.1 connect(X.2 Index)}
		   end
		   State
		catch E then
		   raise cannot_connect(error:E state:State name:State.name type:State.type) end
		end
	     [] disconnect(Port Index) then
		try
		   for X in State.inPorts.Port do
		      {X.1 disconnect(X.2 Index)}
		   end
		   State
		catch E then
		   raise cannot_disconnect(error:E state:State name:State.name type:State.type) end
		end
	     [] bind(OutPort#N Comp Name) then
		try
		   for X in State.outPorts.OutPort do
		      {X.1 bind(X.2#N Comp Name)}
		   end
		   State
		catch E then
		   raise cannot_bind_array(error:E state:State name:State.name type:State.type) end
		end
	     [] bind(OutPort Comp Name) then
		try
		   for X in State.outPorts.OutPort do
		      {X.1 bind(X.2 Comp Name)}
		   end
		   State
		catch E then
		   raise cannot_bind(error:E state:State name:State.name type:State.type) end
		end
	     [] unBound(OutPort N) then
		try
		   for X in State.outPorts.OutPort do
		      {X.1 unBound(X.2 N)}
		   end
		   State
		catch E then
		   raise cannot_unBound(error:E state:State name:State.name type:State.type) end
		end
	     [] start then
		{Start State.graph}
		State
	     [] stop then
		{Stop State.graph}
		State
	     end
	  end
	  TheGraph
	  _
	 }
      end
      EntryPoint
   in
      EntryPoint = proc {$ Msg} {Send Point Msg} end
      % Bind all the parentEntryPoint
      {Record.forAll TheGraph.graph.nodes
       proc{$ Comp}
	  {Comp.comp setParentEntryPoint(EntryPoint)}
       end}
      EntryPoint
   end
   % Initialize the graph
   % 1) create the component
   % 2) make the edges
   % 3) Prepare inPorts
   % 4) Prepare outPorts
   % 5) Prepare Error ports
   fun {Init Name Type G}
      Nodes
      % 1) create the components
      {Record.foldLInd G.nodes
       fun {$ Name Acc Node} C in
	  C = {Fractalide.load Name Node.type}
	  if {HasFeature Node opt} then
	     {C send(options opt(arg:Node.opt) _)}
	     {Record.adjoinAt Acc Name node(type:Node.type opt:Node.opt comp:C)}
	  else
	     {Record.adjoinAt Acc Name node(type:Node.type comp:C)}
	  end
       end
       nodes()
       Nodes
      }
      % 2) edges
      for Edge in G.edges do
	 {Nodes.(Edge.1).comp bind(Edge.2 Nodes.(Edge.4).comp Edge.3)}
      end
      % 3) InPorts : default HALT and the other ones
      InHalt = {Record.foldL Nodes
		fun {$ Acc Comp}
		   {Record.adjoinAt Acc 'HALT' Comp.comp#'HALT'|Acc.'HALT'}
		end
		inPorts('HALT':nil)
	       }
      InPorts = {FoldL G.inLinks
		 fun {$ Acc Name#CompName#PortName}
		    if {List.member Name {Arity Acc}} then
		       {Record.adjoinAt Acc Name Nodes.CompName.comp#PortName|Acc.Name}
		    else
		       {Record.adjoinAt Acc Name Nodes.CompName.comp#PortName|nil}
		    end
		 end
		 InHalt
		}
      % 4) OutPorts
      OutPorts = {FoldL G.outLinks
		  fun {$ Acc Name#CompName#PortName}
		     if {List.member Name {Arity Acc}} then
			{Record.adjoinAt Acc Name Nodes.CompName.comp#PortName|Acc.Name}
		     else
			{Record.adjoinAt Acc Name Nodes.CompName.comp#PortName|nil}
		     end
		  end
		  outPorts
		 }
      % 5) Errors
      Error = {Record.foldL Nodes
	       fun {$ Acc Comp}
		  Comp.comp#'ERROR'|Acc
	       end
	       nil
	      }
      OutPortsFinal = {Record.adjoinAt OutPorts 'ERROR' Error}
   in
      subcomponent(name:Name type:Type inPorts:InPorts outPorts:OutPortsFinal graph:{Record.adjoinAt G nodes Nodes} parentEntryPoint:nil)
   end
   proc {Start Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp}
	  {Comp.comp start}
       end
      }
   end
   proc {Stop Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp} State in
	  {Comp.comp getState(State)}
	  if {Label State} == subcomponent orelse {Record.width State.inPorts} > 1 then
	     {Comp.comp stop}
	  end
       end
      }
   end
end
      