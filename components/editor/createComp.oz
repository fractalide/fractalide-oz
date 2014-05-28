functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.out Event}
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createComp'
		   inPorts(input error)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.input.size} > 0 then {InputProc Ins Out Comp} end
				if {Ins.error.size} > 0 then {ErrorProc Ins Out Comp} end
			     end)
		   )
      }
   end
   proc{InputProc Ins Out Comp} IP IPF C Name in
      IP = {Ins.input.get}
      case {Label IP}
      of createComp then
         % Unique name
	 Name = {VirtualString.toAtom "comp"#@Unique}
	 Unique := @Unique + 1
	 % Transform int in float
	 IPF = create(button:IP.button x:{Int.toFloat IP.x} y:{Int.toFloat IP.y} name:Name)
	 C = {SubComp.new Name "editor/component" "./components/editor/component.fbp"}
	 {Wait C}
	 % Bind the port of the new component and start it
	 {C bind(out Comp.entryPoint input)}
	 {C bind('ERROR' Comp.entryPoint error)}
	 {C send('in' IPF _)}
	 {C start}
      else
	 {SendOut Out IP}
      end
   end
   proc {ErrorProc Ins Out Comp}
      {Out.'ERROR' {Ins.error.get}}
   end
end