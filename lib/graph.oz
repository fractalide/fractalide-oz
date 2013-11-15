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
   exchange:Exchange
define
   fun {NewNode Name}
      node(name: Name
	   inPorts: {NewDictionary}
	   outPorts: {NewDictionary}
	   comp: {NewCell nil}
	  )
   end
   %TODO : For all add and remove, check what to do with the component
   proc {AddIn N Name}
      (N.inPorts).Name := nil
   end
   proc {RemoveIn N Name}
      {Dictionary.remove N.inPorts Name}
   end
   proc {AddOut N Name}
      (N.outPorts).Name := nil
   end
   proc {RemoveOut N Name}
      {Dictionary.remove N.ouPorts Name}
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
   