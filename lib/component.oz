functor
import
   Browser
export
   new:NewComponent
   addInPort:AddInPort
   removeInPort:RemoveInPort
   addOutPort:AddOutPort
   removeOutPort:RemoveOutPort
   changeName:ChangeName
   name:Name
   changeProc:ChangeProc
   bind:Bind
define
   proc {Restart C}
      {Browser.browse restart#@(C.name)#@(C.thr)}
      if @(C.thr) \= nil andthen {Thread.state @(C.thr)} \= terminated then {Thread.terminate @(C.thr)} end
      {NewThread C}
   end
   proc {NewThread C}
      %MakeIp : Read the first element of every entry port, then return the IPs (the element) and the rest of the lists
      fun {MakeIp InStreams}
	 fun{MakeIpRec Xs Acc}
	    case Xs
	    of nil then Acc
	    [] X|Xr then
	       H V in
	       H = X.1 %Head : the name of the port
	       V = X.2.1 %Value : The value of the port
	       Acc.ips.H := V
	       Acc.s.H := X.2.2
	       {MakeIpRec Xr Acc}
	    end
	 end
      in
	 {MakeIpRec {Dictionary.entries InStreams} resp(ips:{NewDictionary} s:{NewDictionary})}
      end
       %CellToContent :
      fun {CellToContent OutPorts}
	 fun {CellToContentRec Ports Acc}
	    case Ports
	    of nil then Acc
	    [] X|Xr then
	       N V in
	       N = X.1
	       V = X.2
	       {CellToContentRec Xr {Adjoin unit(N: @V) Acc}}
	    end
	 end
      in
	 {CellToContentRec {Dictionary.entries OutPorts} portOut()}
      end
      %ExecProc : 
      proc {ExecProc C}
	 In in
	 {Browser.browse @(C.name)#'Wait for IPs'}
	 In = {MakeIp C.inStream}
	 {Browser.browse @(C.name)#'IPs received'}
	 thread {@(C.procedure) In.ips {CellToContent C.outPorts}} end
	 for I in {Dictionary.keys In.s} do
	    C.inStream.I := In.s.I
	 end
	 {ExecProc C}
      end
   in
      thread
	 (C.thr) := {Thread.this}
	 if {Dictionary.isEmpty C.inPorts} then
	    {Browser.browse @(C.name)#'No input port'}
	 else
	    {Browser.browse @(C.name)#'There is ports'}
	    {ExecProc C}
	 end
      end
   end
   fun {NewComponent NewName}
      InP InS Out Name Proc C
   in
      InP = {NewDictionary}
      InS = {NewDictionary}
      Out = {NewDictionary}
      Name = {NewCell NewName}
      Proc = {NewCell proc {$} skip end}
      C = component(inPorts:InP outPorts:Out inStream:InS name:Name procedure:Proc thr:{NewCell nil} l:{NewLock})
      %{NewThread C}
      C
   end
   proc {AddInPort C Name}
      S P in
      lock (C.l) then
	 {NewPort S P}
	 C.inPorts.Name := P
	 C.inStream.Name := S
	 {Restart C}
	 {Browser.browse @(C.name)#'port added'}
      end
   end
   proc {RemoveInPort C Name}
      lock (C.l) then
	 {Dictionary.remove C.inPorts Name}
	 {Dictionary.remove C.inStream Name}
	 {Restart C}
	 {Browser.browse @(C.name)#'port removed'}
      end
   end
   proc {AddOutPort C Name}
      N in
      lock C.l then
	 N = {NewCell nil}
	 C.outPorts.Name := N
      end
   end
   proc {RemoveOutPort C Name}
      lock C.l then
	 {Dictionary.remove C.outPort Name}
      end
   end
   fun {Name C}
      @(C.name)
   end
   proc {ChangeName C Name}
      (C.name) := Name
   end
   proc {ChangeProc C Proc}
      (C.procedure) := Proc
   end
   proc {Bind Out In}
      Out := In
   end
end