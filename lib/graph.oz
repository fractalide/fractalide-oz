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
   startUI: StartUI
   stop: Stop
   getUnBoundPorts: GetUnBoundPorts
define
   Unique = {NewCell 0}
   ComponentCache = {NewDictionary}
   SubComponentCache = {NewDictionary}
   /*Comments
   Return a graph from the specific FBP file.
   PRE : File is a String representing a path to a FBP file.
   POST : Return a record containing the nodes, the external links (for the subcomponent).
          graph(nodes:nodes(name1:node(comp:<P/1> inPortBinded:[...]) name2:node(comp:<P/1> inPortBinded:[...]))
		inLinks:[name#destComp#destPortName name2#destComp2#destPortName2]
		outLinks:[name#destComp#destPortName ...])
   */
   fun {LoadGraph File} FileAtom Grouped in 
      FileAtom = {VirtualString.toAtom File}
      if {Dictionary.member SubComponentCache FileAtom} then
	 Grouped= SubComponentCache.FileAtom
      else F1 F2 Tokens in
	 F1 = {New Open.file init(name:File flags:[read])}
	 {Wait F1}
	 F2 = {F1 read(list:$ size:all)}
	 Tokens = {ToToken F2}
	 Grouped = {RegroupWords Tokens}
	 SubComponentCache.FileAtom := Grouped
      end

      {BuildGraph Grouped}
   end
   /*
   Pre : Characters is a list of charactersrepresented in their string value ("a", "3", ...).
   Post : Some character or group of characters are replaced by a atom. This is a loosing operation because some atom are not repeated twice.
	  Return a list of character and atoms.
	  |-----------+----------|
          | character | atom     |
          |-----------+----------|
          | "\n"      | new_line |
          | ","       | new_line |
          | "->"      | bind     |
          | "=>"      | assign   |
          | "("       | (        |
          | ")"       | )        |
          | " "       | sep      |
          | "%"       | comment  |
          |-----------+----------|
   */
   fun {ToToken Characters}
      fun {PutAtom At Acc}
	 if Acc \= nil andthen Acc.1 == sep then
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
	    [] 37 then %  is for "%", a comment
	       {Rec Cr {PutAtom comment Acc}}
	    else
	    %It's a simple character
	       {Rec Cr C|Acc}
	    end
	 end
      end
   in 
      {Reverse {Rec Characters nil}}
   end
   /*
   Pre : Xs is a list of characters and words.
   Post :  Return a list where some groups of characters are regrouped in list.
           The words are regrouped using the atom as delimiter, except for the '(' and ')' tokens.
           All the characters between " or ' to -> are considered one word.
   */
   fun {RegroupWords Xs}
      fun {Rec Word Acc Xs}
	 case Xs
	 of nil then
	    if Word \= nil then {Reverse Word}|Acc
	    else Acc end
	 [] X|Xr then
	    if X == comment then R in
	       try
		  _#R = {GetUntil new_line Xr}
	       catch not_found(new_line) then
		  R = nil
	       end
	       if Word \= nil then
		  {Rec nil {Reverse Word}|Acc R}
	       else
		  {Rec nil Acc R}
	       end
	    elseif X \= '(' andthen X \=')' andthen {Atom.is X} then
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
   /*
   Pre : Xs is a list of characters or groups of characters, Token is an atom that is use as delimiter.
   Post : A tuple is return. The first value is all the character or groups of characters found until the token (exclude). 
          The second value is the rest of the list (the first value and the token are removed)
   */
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
   /*
   Pre: Graph is a record like the one in the first comment (the record we want to return at final)
        Xs is a list of characters representing a component : Name(Type), where Type is optional.
   Post : Return a tuple. The first value is a atom representing a name.
          The second value is the graph where in the field node then in the field name, we have the component.
	  The Graph is perhaps changed (a component is added).
   */
   fun {GetComp Graph Xs}
      TName G Name Type TypeAtom
   in
      try
	 TName#G = {GetUntil '(' Xs}
	 Name = {VirtualString.toAtom TName}
	 Type#_ = {GetUntil ')' G}
	 TypeAtom = {VirtualString.toAtom Type}
      catch not_found(_) then
	 raise bad_component_declaration({VirtualString.toAtom Xs}) end
      end
      if {List.member Name {Arity Graph.nodes}} then
	 Name#Graph
      else C TheComp NNodes in
	 if Type == "" then raise type_expected(name:Name) end end
	 try
	    if {Dictionary.member ComponentCache TypeAtom} then
	       TheComp = {(ComponentCache.TypeAtom).new Name}
	    else
	       try
		  [C] = {Module.link ["./components/"#Type#".ozf"]}
		  {Wait C}
		  ComponentCache.TypeAtom := C
		  TheComp = {C.new Name}
	       catch system(module(notFound load _)) then
		  skip
	       end
	    end
	    if {Not {IsDet TheComp}} then
	       try
		  TheComp = {SubComponent.new Name TypeAtom "./components/"#Type#".fbp"}
	       catch system(module(notFound load _)) then
		  raise type_not_found(name:Name type:Type) end
	       end
	    end
	 catch Error then
	    raise component_loading_error(Name Type error:Error) end
	 end
	 NNodes = {Record.adjoinAt Graph.nodes Name node(comp:TheComp inPortBinded:nil)}
	 Name#{Record.adjoinAt Graph nodes NNodes}
      end
   end
   /*
   pre : Xs is a list of character representing a name port
   post : return a list of character, where the name is surround by "'". The name is from the first character to the optional "#" or the end of the list.
   */
   fun {SurroundNamePort Xs}
      fun {Rec Xs Acc}
	 case Xs
	 of nil then "'".1|Acc
	 [] X|Xr then 
	    if X == "#".1 then
	       {List.append {Reverse Xr} X|"'".1|Acc}
	    else
	       {Rec Xr X|Acc}
	    end
	 end
      end
   in
      {Reverse {Rec Xs "'".1|nil}}
   end
   /*
   pre : Xs is a list of characters
   post : return a value corresponding to the list of characters
   */
   fun {GetPort Xs}
      try
	 if Xs == bind then raise virtualString_expected_at(Xs) end end
	 {Compiler.virtualStringToValue {SurroundNamePort Xs}}
      catch Error then
	 raise unvalid_port(Xs error:Error) end
      end
   end
   /*
   pre: Xs is a list of characters, group of characters (list) and atoms
   post : return a record representing a FBP graph as describe in the first comment
   */
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
		  try
		     OP = {GetPort Stack.1}
		  catch Error then
		     raise at_component(OC error:Error) end
		  end
		  NName = {VirtualString.toAtom Xr.1}
		  FGraph = {Record.adjoinAt NGraph outLinks NName#OC#OP|NGraph.outLinks}
		  {Rec Stack.2.1|nil Xr FGraph}
	       else IP IC NName NGraph FGraph in% It's an input rename
		  if Xr.2 == nil then raise missing_element_for_assign(Xs) end end
		  IC#NGraph = {GetComp Graph Xr.2.1}
		  try
		     IP = {GetPort Xr.1}
		  catch Error then
		     raise at_component(IC error:Error) end
		  end
		  NName = {VirtualString.toAtom Stack.1}
		  if {Label IP} == '#' then %It's bind to a specific arrayport
		     {NGraph.nodes.IC.comp addinArrayPort(IP.1 IP.2)}
		  end
		  FGraph = {Record.adjoinAt NGraph inLinks NName#IC#IP|NGraph.inLinks}
		  {Rec Stack.1|nil Xr.2 FGraph}
	       end
	    [] bind then OC OP IP IC NGraph FGraph NNode NNodes GraphWithNode in
	       if Stack.1 == nil then raise missing_element_for_bind(output_component_and_output_port) end end
	       if Stack.2 == nil then raise missing_element_for_bind(output_component_or_output_port Stack.1) end end
	       OC#NGraph = {GetComp Graph Stack.2.1}
	       try
		  OP = {GetPort Stack.1}
	       catch Error then
		  raise at_component(OC error:Error) end
	       end
	       if Xr.2 == nil then raise missing_element_for_bind(OC OP '->' Xs) end end
	       IC#FGraph = {GetComp NGraph Xr.2.1}
	       try
		  IP = {GetPort Xr.1}
	       catch X then
		  raise at_component(IC error:X) end
	       end
	       if {Label IP} == '#' then {FGraph.nodes.IC.comp addinArrayPort(IP.1 IP.2)} end
	       %Bind on the component
	       {FGraph.nodes.OC.comp bind(OP FGraph.nodes.IC.comp IP)}
	       %Bind on the graph
	       NNode = {Record.adjoinAt FGraph.nodes.IC inPortBinded IP|FGraph.nodes.IC.inPortBinded}
	       NNodes = {Record.adjoinAt FGraph.nodes IC NNode}
	       GraphWithNode = {Record.adjoinAt FGraph nodes NNodes}
	       {Rec nil Xr.2 GraphWithNode}
	    [] new_line then
	       {Rec nil Xr Graph}
	    [] sep then
	       {Rec Stack Xr Graph}
	    else
	       % It's a word inside " or ', then build an optgen component and put it on stack
	       if X.1 == "\"".1 orelse X.1 == '\"' then Arg Comp Name NNodes NGraph in
		  Arg = {Reverse {Reverse X.2}.2} %remove the brackets
		  Name = {Int.toString @Unique}.1|"GenOPT"
		  Unique := @Unique+1
		  try
		     Comp = {GenOpt.newArgs {VirtualString.toAtom Name} opt(arg:{Compiler.virtualStringToValue Arg})}
		  catch Error then
		     raise unvalid_options(Error Arg) end
		  end
		  NNodes = {Record.adjoinAt Graph.nodes
			    {VirtualString.toAtom Name}
			    node(comp:Comp inPortBinded:nil)} %The name must be unique
		  NGraph = {Record.adjoinAt Graph nodes NNodes}
		  {Rec "output"|{Reverse ')'|'('|{Reverse Name}}|nil Xr NGraph}
	       else
		  {Rec X|Stack Xr Graph}
	       end
	    end
	 end
      end
   in
      {Rec nil Xs graph(inLinks:nil outLinks:nil nodes:nodes())}
   end
   proc {Start Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp}
	     {Comp.comp start}
       end
      }
   end
   proc {StartUI Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp} {Comp.comp startUI} end
      }
   end
   proc {Stop Graph}
      {Record.forAllInd Graph.nodes
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
      {Record.forAllInd Graph.nodes
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
