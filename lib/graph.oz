functor
import
   Browser
   Comp at './component.ozf'
export
   new:NewNode
   addInPort:AddIn
   addOutPort:AddOut
   removeInPort:RemoveIn
   removeOutPort:RemoveOut
   bind:Bind
   unBind:UnBind
   exchange:Exchange
   changeProc: ChangeProc
define
   % A Node Contains
   % Name : An atom that represent the name
   % inPorts : A Dictionary where the key = name of the port
   %                                  val = Out#OutName where Out is an other node and OutName is the name of the port
   % outPorts : the same as InPorts but in the other sens
   % comp : A cell that contains a component
   fun {NewNode Name}
      node(name: Name
	   inPorts: {NewDictionary}
	   outPorts: {NewDictionary}
	   comp: {NewCell {Comp.new nil nil proc {$ I O} skip end}}
	  )
   end
   %TODO : For all add and remove, check what to do with the component
   %If the new port doesn't exist for the component, it's also added to the component.
   proc {AddIn N Name}
      (N.inPorts).Name := nil
      if {HasFeature (@(N.comp)).inPorts Name} == false then
	 {Exchange N {Comp.addInPort @(N.comp) Name}}
      end
   end
   %If the port exist for the component, it's also removed for the component. If the link is bind, we remove the binding.
   proc {RemoveIn N Name}
      T Out OName in
      T = N.inPorts.Name % Out#OName
      if T \= nil then %If the link is bind
	 Out = T.1
	 OName = T.2
	 {UnBind Out OName N Name}
      end
      {Dictionary.remove N.inPorts Name}
      if {HasFeature (@(N.comp)).inPorts Name} then
	 {Exchange N {Comp.removeInPort @(N.comp) Name}}
      end   
   end
   %If the new port doesn't exist for the component, it's also added to the component. 
   proc {AddOut N Name}
      (N.outPorts).Name := nil
      if {HasFeature (@(N.comp)).outPorts Name} == false then
	 {Exchange N {Comp.addOutPort @(N.comp) Name}}
      end
   end
   %If the port exist for the component, it's also removed for the component. If the link is bind, we remove the binding.
   proc {RemoveOut N Name}
      T In IName in
      T = N.outPorts.Name
      if T \= nil then 
	 In = T.1
	 IName = T.2
	 {UnBind N Name In IName}
      end
      {Dictionary.remove N.outPorts Name}
      if {HasFeature (@(N.comp)).outPorts Name} then
	 {Exchange N {Comp.removeOutPort @(N.comp) Name}}
      end
   end
   proc {ChangeProc Node Proc}
      {Exchange Node {Comp.changeProc @(Node.comp) Proc}}
   end
   proc {Bind Out OutName In InName}
      (Out.outPorts).OutName := In#InName
      (In.inPorts).InName := Out#OutName
      try
	 {Comp.bind (@(Out.comp).outPorts).OutName (@(In.comp).inPorts).InName}
      catch _ then
         %TODO : Raise exception and not browse
	 {Browser.browse 'Warning : can\'t bind at component level'}
      end
   end
   proc {UnBind Out OutName In InName}
      (Out.outPorts).OutName := nil
      (In.inPorts).InName := nil
      try
	 ((@(Out.comp).outPorts).OutName) := nil
      catch _ then
	 %TODO raise exception and not browse
	 {Browser.browse 'can\'t unbind'}
      end
   end
   proc {Exchange N NComp}
      %Change Comp
      (N.comp) := NComp
      %Rebind inPorts
      for P in {Dictionary.entries N.inPorts} do
	 if P.2 \= nil then
	    InName Out OutName in 
	    InName = P.1
	    Out = P.2.1
	    OutName = P.2.2
	    try
	       {Comp.bind (@(Out.comp).outPorts).OutName (@(N.comp).inPorts).InName}
	    catch _ then
               %TODO : Raise exception and not browse
	       {Browser.browse 'Warning, the component doesn\'t have the inport : '#InName}
	    end
	 end
      end
      %Rebind outPorts
      for P in {Dictionary.entries N.outPorts} do
	 if P.2 \= nil then
	    In InName OutName in 
	    OutName = P.1
	    In = P.2.1
	    InName = P.2.2
	    try
	       {Comp.bind (@(N.comp).outPorts).OutName (@(In.comp).inPorts).InName}
	    catch _ then
    	       %TODO : Raise exception and not browse
	       {Browser.browse 'Warning, the component doesn\'t have the outport : '#OutName}
	    end
	 end
      end
   end
end
   