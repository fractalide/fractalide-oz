functor
import
   Comp at '../../../lib/component.ozf'
   Compiler
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/link/linkLogic'
		   inPorts(input)
		   outPorts(out toPort fromPort)
		   procedure(proc{$ Ins Out Comp} {InputProc Ins.input Out Comp} end)
		   state(outComp:nil outPortName:nil
			 inComp:nil inPortName:nil
			 bPoint:nil ePoint:nil)
		   )
      }
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
	       {Rec Xr "'".1|X|"'".1|Acc}
	    else
	       {Rec Xr X|Acc}
	    end
	 end
      end
   in
      {Reverse {Rec Xs "'".1|nil}}
   end
   proc{UnBound OutComp OutName InComp InName} ON in
      if OutName \= nil andthen InName \= nil then
	 ON = {Compiler.virtualStringToValue {SurroundNamePort OutName}}
	 {OutComp unBound(ON InComp)}
      end
   end
   proc{Bind OutComp OutName InComp InName} ON IN in
      if OutName \= nil andthen InName \= nil then
	 ON = {Compiler.virtualStringToValue {SurroundNamePort OutName}}
	 IN = {Compiler.virtualStringToValue {SurroundNamePort InName}}
	 {OutComp bind(ON InComp IN)}
      end
   end
   proc{InputProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of outComp then
				  
	 Comp.state.outComp := IP.comp
	 Comp.state.bPoint := IP.bPoint

	 {Comp.state.bPoint bind(action#move Comp.parentEntryPoint moveBegin)}
	 {Comp.state.bPoint bind(action#delete Comp.parentEntryPoint 'in')}

      [] inComp then
	 Comp.state.inComp := IP.comp
	 Comp.state.ePoint := IP.ePoint
				  % bind for the line
				  
	 {IP.ePoint bind(action#move Comp.parentEntryPoint moveEnd)}
	 {IP.ePoint bind(action#delete Comp.parentEntryPoint 'in')}
	 % Show the line just after creation
	 {Out.out displayLink(Comp.parentEntryPoint to:Comp.state.inPortName 'from':Comp.state.outPortName)}
      [] toPortChange then
	 {Out.toPort set(text:IP.1)}
	 {UnBound Comp.state.outComp Comp.state.outPortName Comp.state.inComp Comp.state.inPortName}
	 {Bind Comp.state.outComp Comp.state.outPortName Comp.state.inComp IP.1}
	 Comp.state.inPortName := IP.1
      [] fromPortChange then
	 {Out.fromPort set(text:IP.1)}
	 {UnBound Comp.state.outComp Comp.state.outPortName Comp.state.inComp Comp.state.inPortName}
	 {Bind Comp.state.outComp IP.1 Comp.state.inComp Comp.state.inPortName}
	 Comp.state.outPortName := IP.1
      [] delete then
	 {UnBound Comp.state.outComp Comp.state.outPortName Comp.state.inComp Comp.state.inPortName}
	 %{System.show linklogic#Comp.parentEntryPoint}
				  % unbound for the line
	 %{Comp.state.bPoint unBound(action#move Comp.parentEntryPoint)}
	 %{Comp.state.ePoint unBound(action#move Comp.parentEntryPoint)}
				  % "real" comp
	 %if Comp.state.outPortName \= nil andthen Comp.state.inPortName \= nil then
	    %{Comp.state.outComp unBound({VirtualString.toAtom Comp.state.outPortName} Comp.state.inComp)}
	 %end
      [] open then
	 skip
      [] close andthen {HasFeature IP comp} then
	 skip
      [] close then
	 skip
      [] 'ButtonRelease' then
	 {Out.out displayLink(Comp.parentEntryPoint to:Comp.state.inPortName 'from':Comp.state.outPortName)}
      end
   end
end