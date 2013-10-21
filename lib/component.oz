functor
export
   new:NewComponent
   bind:Bind
define
%NewComponent :
%InPorts : List of string which are the input port name    ex : [above middle bellow]
%OutPorts : Idem for the output ports                      ex : [accept reject]
%Proc : A proc which take 2 args : the Ips by input ports (a record) and the Output ports to send cmd
%           ex: proc {Filter In Out} {Send Out.accept In.above} end
   fun {NewComponent InPorts OutPorts Proc}
   %InToPort : Convert a list of string in a record containing the Port (entry point in the record p:() and the stream in a list s:())
      fun {InToPort Ls}
	 fun {InToPortRec Ls Acc}
	    case Ls
	    of nil then Acc
	    [] L|Lr then
	       P S in
	       {NewPort S P}
	       {InToPortRec Lr portIn(p:{Adjoin unit(L: P) Acc.p} s:L#S|Acc.s)}
	    end
	 end
      in
	 {InToPortRec Ls portIn(p:p() s:nil)}
      end
   %OutToPort : Convert a list of string in a record containing cells, destined to be entry point for the Out port
      fun {OutToPort Ls}
	 fun {OutToPortRec Ls Acc}
	    case Ls
	    of nil then Acc
	    [] L|Lr then
	       P in
	       P = {NewCell nil}
	       {OutToPortRec Lr {Adjoin unit(L: P) Acc}}
	    end
	 end
      in
	 {OutToPortRec Ls portOut()}
      end
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
   %CellToContent : Take a records of Cells and return a record with the same arity but the content of the cells
      fun {CellToContent OutPorts}
	 fun {CellToContentRec Ports Acc}
	    case Ports
	    of nil then Acc
	    [] X|Xr then
	       T in
	       T = OutPorts.X
	       {CellToContentRec Xr {Adjoin unit(X: @T) Acc}}
	    end
	 end
      in
	 {CellToContentRec {Arity OutPorts} portOut()}
      end
   %ExecProc : 
      proc {ExecProc InStreams OutPorts Proc}
	 In in
	 In = {MakeIp InStreams}
	 thread {Proc In.ips {CellToContent OutPorts}} end
	 {ExecProc In.s OutPorts Proc}
      end
      In Out
   in
      In = {InToPort InPorts}
      Out = {OutToPort OutPorts}
      thread
	 {ExecProc In.s Out Proc}
      end
      component(inPorts:In.p outPorts:Out)
   end
   proc {Bind Out In}
      Out := In
   end
end



