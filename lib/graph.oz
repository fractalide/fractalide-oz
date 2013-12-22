functor
import
   Compiler
   Open
   Module
export
   loadGraph: LoadGraph
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
      fun {GetComp NameComp TypeComp Graph}
	 TheComp NGraph in
	 try
	    TheComp = Graph.NameComp
	    NGraph = Graph
	 catch _ then
	    TheComp = {LoadComponent TypeComp}
	    NGraph = {Record.adjoinAt Graph NameComp TheComp}
	 end
	 TheComp#NGraph
      end
      fun {Begin State Graph File}
	 case File.1
	 of 34 then S S2 F in
	    S#F = {ReadUntil File.2 "\""}
	    S2 = {Compiler.virtualStringToValue S}
	    {Record.adjoinList State [ic#string ip#S2]}#Graph#F.2
	 else
	    TheComp NameComp TypeComp NamePort NGraph F F2 in
	    NameComp#TypeComp#F = {ReadComp File}
	    NamePort#F2 = {ReadPort F}
	    TheComp#NGraph = {GetComp NameComp TypeComp Graph}
	    {Record.adjoinList State [ic#TheComp ip#NamePort]}#NGraph#F2
	 end
      end
      fun {ReadOut State Graph File}
	 NameComp TypeComp NamePort TheComp NGraph NFile F2 in
	 NamePort#F2 = {ReadPort File}
	 NameComp#TypeComp#NFile = {ReadComp F2}
	 TheComp#NGraph = {GetComp NameComp TypeComp Graph}
	 {Record.adjoinList State [op#NamePort oc#TheComp]}#NGraph#NFile
      end
      fun {Rec State#Graph#File}
	 case State
	 of state(ic:nil ip:nil op:nil oc:nil) then
	    {Rec {Begin State Graph File}}
	 [] state(ic:_ ip:_ op:nil oc:nil) then F in
	    _#F = {ReadUntil File " "} %Remove arrow
	    {Rec {ReadOut State Graph F}}
	 [] state(ic:IC ip:IP op:OP oc:OC) then
	 %Make the link
	    if IC == string then
	       {OC send(options IP)}
	    else
	       case OP
	       of P#_ then
		  {OC addinArrayPort(P)}
	       else
		  skip
	       end
	       {IC bind(IP OC OP)}
	    end
	    if File == nil then
	       Graph
	 %If , \n then {Rec(ic:nil ip:nil op:nil oc:nil)}#NGraph#NFile)}
	    elseif File.1 == ",".1 orelse File.1 == "\n".1 then
	       {Rec state(ic:nil ip:nil op:nil oc:nil)#Graph#File.2}
	 %Elseif EOF Graph
	 %Else : {ReadOPort state(ic:OC ip:{ReadComp} op:nil oc:nil)
	    else NamePort NFile in
	       NamePort#NFile = {ReadPort File}
	       {Rec state(ic:State.oc ip:NamePort op:nil oc:nil)#Graph#NFile}
	    end
	 end
      end
      F1 F2
   in 
      F1 = {New Open.file init(name:"test.fbp" flags:[read])}
      F2 = {F1 read(list:$)}
      {Rec state(ic:nil ip:nil op:nil oc:nil)#graph()#F2}
   end
end