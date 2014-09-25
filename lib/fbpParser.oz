/*
<one line to give the program's name and a brief idea of what it does.>
Copyright (C) 2014 Denis Michiels

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
   Compiler
export
   parse: Parse
define
   % Return the record graph from a VirtualString representing a .fbp file
   fun {Parse Ls}
      L P in
      L = {Lexical Ls}
      P = {New Parser init(L)}
      {Syntaxic P}
   end
   % Do the lexical analysis of a .fbp file
   % PRE : A virtualstring representing a .fbp file
   % POST : a list of tuple. The first feature is a type (newLine, port, componentName, componentType, bindPort, bindVirtual, options), the second feature is the element
   fun {Lexical Ls}
      % Return if L is in [a-z], or in [A-Z], or in [0-9], or is "_", or is "/"
      fun {IsName L}
	 (L >= 97 andthen L =< 122) orelse (L >= 65 andthen L =< 90) orelse (L >= 48 andthen L =< 57) orelse L == 95 orelse L == 47
      end
      fun {Rec Ls Stack State Acc}
	 case Ls
	 of nil then
	    if State == name then N in
	       N = {Compiler.virtualStringToValue {Reverse "'".1|Stack}}
	       {Reverse port#N|Acc}
	    elseif State == base orelse State == comment then
	       {Reverse Acc}
	    else
	       raise unexcepted_eof end
	    end
	 [] L|Lr then
	    case State
	    of base then
	       if L == "-".1 then
		  {Rec Lr nil bindPort Acc}
	       elseif L == "=".1 then
		  {Rec Lr nil bindVirtual Acc}
	       elseif L == " ".1 then
		  {Rec Lr nil base Acc}
	       elseif L == "\n".1 orelse L == ",".1 then
		  {Rec Lr nil base newLine#"\n" | Acc}
	       elseif L == "%".1 then
		  {Rec Lr nil comment Acc}
	       elseif L == "\"".1 then
		  {Rec Lr nil options Acc}
	       elseif {IsName L} then
		  {Rec Ls "'".1|nil name Acc}
	       else
		  raise unexcepted_token(found:L) end
	       end
	    [] name then
	       if L == "(".1 then N in
		  N = {Compiler.virtualStringToValue {Reverse "'".1|Stack}}
		  {Rec Lr "'".1|nil componentType componentName#N | Acc}
	       elseif {IsName L} then % ALPHANUM
		  {Rec Lr L|Stack name Acc}
	       elseif L == "#".1 then
		  {Rec Lr "'".1|"#".1|"'".1|Stack name Acc}
	       else P in
		  P = {Compiler.virtualStringToValue {Reverse "'".1|Stack}}
		  {Rec Ls nil base port#P | Acc}
	       end
	    [] componentType then
	       if L == ")".1 then N in
		  N = {Compiler.virtualStringToValue {Reverse "'".1|Stack}}
		  {Rec Lr nil base componentType#N | Acc}
	       elseif {IsName L} then % ALPHANUM
		  {Rec Lr L|Stack componentType Acc}
	       else
		  raise unvalid_componentType(stack:{Reverse Stack} character:L) end
	       end
	    [] bindPort then
	       if L == ">".1 then
		  {Rec Lr nil base bindPort#"->" | Acc}
	       else
		  raise unvalid_arrow(expected:'->' found:L) end
	       end
	    [] bindVirtual then
	       if L == ">".1 then
		  {Rec Lr nil base bindVirtual#"=>" | Acc}
	       else
		  raise unvalid_arrow(expected:'=>' found:L) end
	       end
	    [] comment then
	       if L == "\n".1 then
		  {Rec Lr nil base Acc}
	       else
		  {Rec Lr nil comment Acc}
	       end
	    [] options then
	       if L == "\\".1 then
		  if Lr == nil then raise unexcepted_end_of_options end end
		  {Rec Lr.2 Lr.1|Stack options Acc}
	       elseif L == "\"".1 then
		  {Rec Lr nil base options#{Compiler.virtualStringToValue {Reverse Stack}} | Acc}
	       else
		  {Rec Lr L|Stack options Acc}
	       end
	    end
	 end
      end
   in
      {Rec Ls nil base nil}
   end
   class Parser
      attr ls l
      meth init(Ls)
	 ls := Ls
	 l := {NewLock}
      end
      meth is(Type R)
	 if @ls \= nil andthen (@ls).1.1 == Type then R = true
	 else R = false
	 end
      end
      meth read(Type R)
	 if @ls == nil then
	    raise  missing_element(expected:Type found:eof) end
	 end
	 if (@ls).1.1 \= Type then
	    raise wrong_element(expected:Type found:(@ls).1.1 ls:@ls) end
	 end
	 R = (@ls).1.2
      end
      meth get(Type R)
	 lock @l then
	    {self read(Type R)}
	    ls := (@ls).2
	 end
      end
      meth put(El)
	 lock @l then
	    ls := El|@ls
	 end
      end
      meth empty(R)
	 if @ls == nil then R = true
	 else R = false end
      end
   end
   /* PRE : Ls is a Parser object
   POST : a record representing a graph of nodes
   graph(nodes:nodes(name1:node(type:aType) name2:node(type:anOtherType))
	 edges:[name1#port1#name2#port2 ...]
	 inLinks:[name#destComp#destPortName...]
	 outLinks:[name#destComp#destPortName...]
	)
   */
   fun {Syntaxic Ls}
      Unique = {NewCell 0}
      fun {AddComp Graph ComponentName ComponentType}
	 if {HasFeature Graph.nodes ComponentName} then
	    if ComponentType \= '' andthen Graph.nodes.ComponentName.type \= ComponentType then
	       raise bad_component_declaration(error:type_missmatch previous:Graph.nodes.ComponentName.type given:ComponentType componentName:ComponentName) end
	    end
	    Graph
	 else NNodes in
	    if ComponentType == '' then
	       raise component_type_missing(name:ComponentName) end
	    end
	    NNodes = {Record.adjoinAt Graph.nodes ComponentName node(type:ComponentType)}
	    {Record.adjoinAt Graph nodes NNodes}
	 end
      end
      fun {Rec Graph}
	 if {Ls empty($)} then Graph
	 else
	    if {Ls is(port $)} then VP P CN CT NGraph in
	    % Expecting "port => port componentName componentType"
	       {Ls get(port VP)}
	       {Ls get(bindVirtual _)}
	       {Ls get(port P)}
	       {Ls get(componentName CN)}
	       {Ls read(componentType CT)}
	       {Ls put(componentName#CN)}
	       NGraph = {AddComp Graph CN CT}
	       {Rec {Record.adjoinAt NGraph inLinks VP#CN#P|NGraph.inLinks}}
	    elseif {Ls is(componentName $)} then CN CT NGraph in
	    % Expecting "componentName componentType"
	       {Ls get(componentName CN)}
	       {Ls get(componentType CT)}
	       NGraph = {AddComp Graph CN CT}
	    % then
	       %% empty    end of line or file
	       if {Ls empty($)} then {Rec NGraph}
	       elseif {Ls is(newLine $)} then {Ls get(newLine _)} {Rec NGraph}
	       elseif {Ls is(port $)} then P in
		  %% or 
		  %% "port"
		  {Ls get(port P)}
		  %% then
%%% "-> port componentName componentType
		  if {Ls is(bindPort $)} then IP ICN ICT N2Graph in
		     {Ls get(bindPort _)}
		     {Ls get(port IP)}
		     {Ls get(componentName ICN)}
		     {Ls read(componentType ICT)}
		     {Ls put(componentName#ICN)}
		     N2Graph = {AddComp NGraph ICN ICT}
		     {Rec {Record.adjoinAt N2Graph edges CN#P#IP#ICN|N2Graph.edges}}
%%% or
%%% "=> port
		  else VP in
		     {Ls get(bindVirtual _)}
		     {Ls get(port VP)}
		     {Rec {Record.adjoinAt NGraph outLinks VP#CN#P|NGraph.outLinks}}
		  end
	       end
	    elseif {Ls is(newLine $)} then
	       {Ls get(newLine _)}
	       {Rec Graph}
	    else C IP ICN ICT Name NNodes NGraph N2Graph in
	       % options
	       {Ls get(options C)}
	       {Ls get(bindPort _)}
	       {Ls get(port IP)}
	       {Ls get(componentName ICN)}
	       {Ls read(componentType ICT)}
	       {Ls put(componentName#ICN)}
	       Name = {VirtualString.toAtom {List.append {Int.toString @Unique} "GenOPT"}}
	       Unique := @Unique + 1
	       NNodes = {Record.adjoinAt Graph.nodes Name node(type:genopt opt:C)}
	       NGraph = {Record.adjoinAt Graph nodes NNodes}
	       N2Graph = {AddComp NGraph ICN ICT}
	       {Rec {Record.adjoinAt N2Graph edges Name#output#IP#ICN|N2Graph.edges}}
	    end
	 end
      end
   in
      {Rec graph(nodes:nodes() inLinks:nil outLinks:nil edges:nil)}
   end
end