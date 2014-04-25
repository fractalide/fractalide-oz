functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   fun {OutPortWrapper Out} 
      proc{$ send(_ Msg Ack)}
	 {SendOut Out Msg}
	 Ack = ack
      end
   end
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.actions_out Event}
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createComp'
		   inPorts(
		      input(proc{$ In Out Comp} IP IPF C Name in
			       IP = {In.get}
			       % Unique name
			       Name = {VirtualString.toAtom "comp"#@Unique}
			       Unique := @Unique + 1
			       % Transform int in float
			       IPF = doubleclick(button:IP.button x:{Int.toFloat IP.x} y:{Int.toFloat IP.y} name:Name)
			       C = {SubComp.new Name "editor/component" "./components/editor/component.fbp"}
			       {Wait C}
			       % Bind the port of the new component and start it
			       {C bind(ui_out {OutPortWrapper Out} widget_out)}
			       {C bind(actions_out {OutPortWrapper Out} actions_out)}
			       {C send(ui_in IPF _)}
			       {C start}
			    end)
		      )
		   outPorts(widget_out actions_out)
		   outArrayPorts(action)
		   )
      }
   end
end