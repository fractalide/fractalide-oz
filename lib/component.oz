functor
export
   new:NewComponent
   addInPort:AddInPort
   removeInPort:RemoveInPort
   addOutPort:AddOutPort
   removeOutPort:RemoveOutPort
   changeName:ChangeName
   name:Name
   changeProc:ChangeProc
   %bind:Bind
define
   fun {NewComponent NewName}
      InP InS Out Name Proc
      %MakeIp : Read the first element of every entry port, then return the IPs (the element) and the rest of the lists
      fun {MakeIp InStreams}
	 fun{MakeIpRec Xs Acc}
	    case Xs
	    of nil then Acc
	    [] X|Xr then
	       H V in
	       H = X.1 %Head : The name of the port
	       V = X.2.1 %Value : The value of the IP
	       {MakeIpRec Xr resp(ips:{Adjoin unit(H: V) Acc.ips} s:X.1#X.2.2|Acc.s)}
	    end
	 end
      in
	 {MakeIpRec InStreams resp(ips:ips() s:nil)}
      end
      %ExecProc : 
      proc {ExecProc InStreams OutPorts Proc}
	 In B in
	 In = {MakeIp InStreams}
	 B = {Dictionary
	 thread {Proc In.ips {CellToContent OutPorts}} end
	 {ExecProc In.s OutPorts Proc}
      end
   in
      InP = {NewDictionary}
      InS = {NewDictionary}
      Out = {NewDictionary}
      NIp = {NewDictionary}
      Name = {NewCell NewName}
      Proc = {NewCell proc {$} skip end}
      component(inPorts:InP outPorts:Out inStream:InS nIP:NIp name:Name procedure:Proc)
   end
   proc {AddInPort C Name}
      S P in
      {NewPort S P}
      C.inPorts.Name := P
      C.inStream.Name := S
   end
   proc {RemoveInPort C Name}
      {Dictionary.remove C.inPort Name}
      {Dictionary.remove C.inStream Name}
   end
   proc {AddOutPort C Name}
      N in
      N = {NewCell nil}
      C.outPort.Name := N
   end
   proc {RemoveOutPort C Name}
      {Dictionary.remove C.outPort Name}
   end
   fun {Name C}
      @(C.name)
   end
   proc {ChangeName C Name}
      C.name := Name
   end
   proc {ChangeProc C Proc}
      C.procedure := Proc
   end
   proc {CSend C Name Val}
      {Send @(C.outPort.Name) Val}
   end
end