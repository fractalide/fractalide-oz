functor
import
   Compiler
   Open
   Module
   SubComponent at './subcomponent.ozf'
   GenOpt at '../components/genopt.ozf'
export
   loadGraph: LoadGraph
   start: Start
   stop: Stop
   getUnBoundPorts: GetUnBoundPorts
define
   fun {LoadGraph File}
      F1 = {New Open.file init(name:File flags:[read])}
      F2 = {F1 read(list:$)}
      Tokens = {ToToken F2}
      Grouped = {RegroupWords Tokens}
   in
      {BuildGraph Grouped}
   end
   fun {ToToken Characters}
      fun {PutAtom At Acc}
	 if Acc.1 == sep then
	    At|Acc.2
	 else
	    At|Acc
	 end
      end
      fun {Rec Cs Acc}
	 case Cs
	 of nil then Acc
	 [] C|Cr then
	    case C
	       %% new_line
	    of 10 then % 10 is "\n"
	       if Acc \= nil andthen Acc.1 \= new_line then
		  {Rec Cr {PutAtom new_line Acc}}
	       else
		  {Rec Cr Acc}
	       end
	    [] 44 then % 44 is ","
	       if Acc \= nil andthen Acc.1 \= new_line then
		  {Rec Cr {PutAtom new_line Acc}}
	       else
		  {Rec Cr Acc}
	       end
	       %% Bind and assign
	    [] 62 then % 62 is ">"    45 is "-"
	       if Acc \= nil andthen Acc.1 == "-".1 then % It's a bind 
		  {Rec Cr {PutAtom bind Acc.2}}
	       elseif Acc \= nil andthen Acc.1 == "=".1 then  % It's an assign
		  {Rec Cr {PutAtom assign Acc.2}}
	       else %It's nothing
		  {Rec Cr C|Acc}
	       end
	       %%parents
	    [] 40 then {Rec Cr '('|Acc}
	    [] 41 then {Rec Cr ')'|Acc}
	       %% New word and space
	    [] 32 then % 32 is for " "
	       if (Acc == nil orelse (Acc.1 \= '(' andthen Acc.1 \= ')' andthen {Atom.is Acc.1})) then
		  {Rec Cr Acc}
	       else
		  {Rec Cr sep|Acc}
	       end
	    else
	    %It's a simple character
	       {Rec Cr C|Acc}
	    end
	 end
      end
   in 
      {Reverse {Rec Characters nil}}
   end
   fun {RegroupWords Xs}
      fun {Rec Word Acc Xs}
	 case Xs
	 of nil then
	    if Word \= nil then {Reverse Word}|Acc
	    else Acc end
	 [] X|Xr then
	    if X \= '(' andthen X \=')' andthen {Atom.is X} then
	       if X \= sep then %Remove the sep 
		  {Rec nil X|{Reverse Word}|Acc Xr}
	       else
		  {Rec nil {Reverse Word}|Acc Xr}
	       end
	    elseif X == "\"".1 orelse X == "\'".1 then W R in
	       W#R = {GetUntil bind Xs}
	       {Rec nil bind|W|Acc R}
	    else
	       {Rec X|Word Acc Xr}
	    end
	 end
      end
   in
      {Reverse {Rec nil nil Xs}}
   end
   fun {GetUntil Token Xs}
      fun {Rec Xs Acc}
	 if Xs ==  nil then raise not_found(Token) end
	 else
	    X|Xr = Xs
	 in
	    if X == Token then {Reverse Acc}#Xr
	    else NAcc in
	       if {Atom.is X} then
		  case X
		  of '(' then NAcc = "(".1 | Acc
		  [] ')' then NAcc = ")".1 | Acc
		  [] sep then NAcc = " ".1 | Acc
		  [] new_line then NAcc = "\n".1 | Acc
		  [] bind then NAcc = ">".1 | "-".1 | Acc
		  [] assign then NAcc = ">".1 | "=".1 | Acc
		  end
	       else
		  NAcc = X | Acc
	       end
	       {Rec Xr NAcc}
	    end
	 end
      end
   in
      {Rec Xs nil}
   end
   fun {GetComp Graph Xs}
      TName#G = {GetUntil '(' Xs}
      Name = {VirtualString.toAtom TName}
      Type#_ = {GetUntil ')' G}
   in
      if {List.member Name {Arity Graph}} then
	 Name#Graph
      else C TheComp in
	 try
	    [C] = {Module.link ["./components/"#Type#".ozf"]}
	    TheComp = {C.new}
	 catch _ then
	    TheComp = {SubComponent.new "/home/denis/ucl/flowVM/components/"#Type#".fbp"}
	 end
	 Name#{Record.adjoinAt Graph Name node(comp:TheComp inPortBinded:nil)}
      end
   end
   fun {BuildGraph Xs}
      fun {Rec Stack Xs Graph}
	 case Xs
	 of nil then Graph
	 [] X|Xr then
	    case X
	    of assign then
	       if Xr.2 == nil orelse {Atom.is Xr.2.1} then %It's an output rename
		  OC OP NName NGraph FGraph
	       in 
		  OC#NGraph = {GetComp Graph Stack.2.1}
		  OP = {Compiler.virtualStringToValue Stack.1}
		  NName = {VirtualString.toAtom Xr.1}
		  FGraph = {Record.adjoinAt NGraph outLinks NName#OC#OP|NGraph.outLinks}
		  {Rec Stack.2.1|nil Xr FGraph}
	       else IP IC NName NGraph FGraph in% It's an input rename
		  IC#NGraph = {GetComp Graph Xr.2.1}
		  IP = {Compiler.virtualStringToValue Xr.1}
		  NName = {VirtualString.toAtom Stack.1}
		  FGraph = {Record.adjoinAt NGraph inLinks NName#IC#IP|NGraph.inLinks}
		  {Rec Stack.1|nil Xr.2 FGraph}
	       end
	    [] bind then OC OP IP IC NGraph FGraph NNode GraphWithNode in
	       OC#NGraph = {GetComp Graph Stack.2.1}
	       OP = {Compiler.virtualStringToValue Stack.1}
	       IP = {Compiler.virtualStringToValue Xr.1}
	       IC#FGraph = {GetComp NGraph Xr.2.1}
	       if {Label IP} == '#' then {FGraph.IC.comp addinArrayPort(IP.1)} end
	       %Bind on the component
	       {FGraph.OC.comp bind(OP FGraph.IC.comp IP)}
	       %Bind on the graph
	       NNode = {Record.adjoinAt FGraph.IC inPortBinded IP|FGraph.IC.inPortBinded}
	       GraphWithNode = {Record.adjoinAt FGraph IC NNode}
	       {Rec nil Xr.2 GraphWithNode}
	    [] new_line then
	       {Rec nil Xr Graph}
	    [] sep then
	       {Rec Stack Xr Graph}
	    else
	       % It's a word inside " or ', then build an optgen component and put it on stack
	       if X.1 == "\"".1 orelse X.1 == '\"' then Arg Comp Name NGraph in
		  Arg = {Reverse {Reverse X.2}.2} %remove the brackets
		  Comp = {GenOpt.newArgs opt(arg:{Compiler.virtualStringToValue Arg})}
		  Name = {Int.toString {Length Xr}}.1|"GenOPT"
		  NGraph = {Record.adjoinAt Graph
			    {VirtualString.toAtom Name}
			    node(comp:Comp inPortBinded:nil)} %The name must be unique
		  {Rec output|{Reverse ')'|'('|{Reverse Name}}|nil Xr NGraph}
	       else
		  {Rec X|Stack Xr Graph}
	       end
	    end
	 end
      end
   in
      {Rec nil Xs graph(inLinks:nil outLinks:nil)}
   end
   proc {Start Graph}
      {Record.forAllInd Graph
       proc {$ Ind Comp} State in
	  if Ind \= inLinks andthen Ind \= outLinks then % Due to inLinks and outLinks
	     {Comp.comp getState(State)}
	     if {Label State} == subcomponent orelse {Record.width State.inPorts} == 0 then
		{Comp.comp start}
	     end
	  end
       end
      }
   end
   proc {Stop Graph}
      {Record.forAllInd Graph
       proc {$ Ind Comp} State in
	  if Ind \= inLinks andthen Ind \= outLinks then
	     {Comp.comp getState(State)}
	     if {Label State} == subcomponent orelse {Record.width State.inPorts} == 0 then
	     {Comp.comp stop}
	     end
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
