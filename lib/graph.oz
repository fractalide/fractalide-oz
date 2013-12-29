functor
import
   Compiler
   Open
   Module
export
   loadGraph: LoadGraph
   start: Start
   stop: Stop
   getUnBoundPorts: GetUnBoundPorts
define
   fun {LoadGraph File}
      fun {LoadComponent Name}C in
	 [C] = {Module.link ["./components/"#Name#".ozf"]}
	 {C.new}
      end
      fun {ReadNextWord File}
	 fun {Rec File Acc}
	    case File
	    of nil then {Reverse Acc}#nil
	    [] Char|Fs then
	       if Char == " ".1 then
		  {Reverse Acc}#Fs
	       elseif Char == ",".1 orelse Char == "\n".1 then
		  {Reverse Acc}#File
	       else
		  {Rec Fs Char|Acc}
	       end
	    end
	 end
      in
	 {Rec File nil}
      end
      fun {ReadUntil File Del}
	 fun {Rec File Acc}
	    case File
	    of nil then Acc
	    [] Char|Fs then
	       if Char == Del.1 then
		  {Reverse Acc}#Fs
	       else
		  {Rec Fs Char|Acc}
	       end
	    end
	 end
      in
	 {Rec File nil}
      end
      fun {ReadComp File}
	 NameComp TypeComp Tot Tot2 F in
	 Tot#F = {ReadNextWord File}
	 NameComp#Tot2 = {ReadUntil Tot "("}
	 TypeComp#_ = {ReadUntil Tot2 ")"}
	 {String.toAtom NameComp}#TypeComp#F
      end
      fun {ReadPort File}
	 NamePortS F in
	 NamePortS#F = {ReadNextWord File}
	 {Compiler.virtualStringToValue NamePortS}#F
      end
      fun {InitComp NameComp TypeComp Graph}
	 NGraph in
	 if TypeComp == nil then
	    NGraph = Graph
	 else TheComp Node in
	    TheComp = {LoadComponent TypeComp}
	    Node = node(comp:TheComp inPortBinded:nil)
	    NGraph = {Record.adjoinAt Graph NameComp Node}
	 end
	 NGraph
      end
      fun {Begin State Graph File}
	 case File.1
	 of 34 then S S2 F in
	    S#F = {ReadUntil File.2 "\""}
	    S2 = {Compiler.virtualStringToValue S}
	    {Record.adjoinList State [ic#string ip#S2]}#Graph#F.2
	 else
	    NameComp TypeComp NamePort NGraph F F2 in
	    NameComp#TypeComp#F = {ReadComp File}
	    NamePort#F2 = {ReadPort F}
	    NGraph = {InitComp NameComp TypeComp Graph}
	    {Record.adjoinList State [ic#NameComp ip#NamePort]}#NGraph#F2
	 end
      end
      fun {ReadOut State Graph File}
	 NameComp TypeComp NamePort NGraph NFile F2 in
	 NamePort#F2 = {ReadPort File}
	 NameComp#TypeComp#NFile = {ReadComp F2}
	 NGraph = {InitComp NameComp TypeComp Graph}
	 {Record.adjoinList State [op#NamePort oc#NameComp]}#NGraph#NFile
      end
      fun {Rec State#Graph#File}
	 case State
	 of state(ic:nil ip:nil op:nil oc:nil) then
	    {Rec {Begin State Graph File}}
	 [] state(ic:_ ip:_ op:nil oc:nil) then F in
	    _#F = {ReadUntil File " "} %Remove arrow
	    {Rec {ReadOut State Graph F}}
	 [] state(ic:IC ip:IP op:OP oc:OC) then NGraph NNode in
	 %Make the link
	    if IC == string then
	       {Graph.OC.comp send(options IP _)}
	       NGraph = Graph
	    else
	       case OP
	       of P#_ then
		  {Graph.OC.comp addinArrayPort(P)}
	       else
		  skip
	       end
	       NNode = {Record.adjoinAt Graph.OC inPortBinded OP|Graph.OC.inPortBinded}
	       NGraph = {Record.adjoinAt Graph OC NNode}% Add the information in the graph that the port is binded
	       {Graph.IC.comp bind(IP Graph.OC.comp OP)} %At component level
	    end
	    if File == nil then
	       NGraph
	 %If , \n then {Rec(ic:nil ip:nil op:nil oc:nil)}#NGraph#NFile)}
	    elseif File.1 == ",".1 orelse File.1 == "\n".1 then
	       {Rec state(ic:nil ip:nil op:nil oc:nil)#NGraph#File.2}
	 %Elseif EOF Graph
	 %Else : {ReadOPort state(ic:OC ip:{ReadComp} op:nil oc:nil)
	    else NamePort NFile in
	       NamePort#NFile = {ReadPort File}
	       {Rec state(ic:State.oc ip:NamePort op:nil oc:nil)#NGraph#NFile}
	    end
	 end
      end
      F1 F2
   in 
      F1 = {New Open.file init(name:File flags:[read])}
      F2 = {F1 read(list:$)}
      {Rec state(ic:nil ip:nil op:nil oc:nil)#graph()#F2}
   end
   proc {Start Graph}
      {Record.forAll Graph
       proc {$ Comp} State in
	  {Comp.comp getState(State)}
	  if {Label State} == subcomponent orelse {Record.width State.inPorts} == 0 then
	     {Comp.comp start}
	  end
       end
      }
   end
   proc {Stop Graph}
      {Record.forAll Graph
       proc {$ Comp} State in
	  {Comp.comp getState(State)}
	  if {Label State} == subcomponent orelse {Record.width State.inPorts} == 0 then
	     {Comp.comp stop}
	  end
       end
      }
   end
   fun {GetUnBoundPorts Graph}
      fun {OutPorts Name State} Value in
	 Value = State.outPorts.Name
	 if {Label State} == component then Value
	 else NState in
	    {(Value.1) getState(NState)}
	    {OutPorts Value.2 NState}
	 end
      end
      Out = {NewCell nil}
      In = {NewCell nil}
   in
      {Record.forAllInd Graph
       proc {$ Name node(comp:Comp inPortBinded:Binded)} State in
	  {Comp getState(State)}
	  {Record.forAllInd State.outPorts
	   proc {$ OName _} Attatch in
	      Attatch = {OutPorts OName State}
	      if Attatch == nil then Out := Comp#Name#OName | @Out end
	   end}
	  {Record.forAllInd State.inPorts
	   proc {$ IName Port}
	      case Port
	      of port(p:_ q:_ s:_) then
		 if {Not {List.member IName Binded}} then In := Comp#Name#IName | @In end
	      [] arrayPort(p:_ qs:Qs s:_) then NArity in
		 NArity = {Map {Arity Qs} fun {$ X} IName#X end}
		 for X in NArity do
		    if {Not {List.member X Binded}} then In := Comp#Name#X | @In end
		 end
	      [] _#_ then
		 if {Not {List.member IName Binded}} then In := Comp#Name#IName | @In end
	      end
	   end}
       end}
      @In#@Out
   end
end
