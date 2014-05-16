functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   fun {OutPortWrapper Out} 
      proc{$ send(Port Msg Ack)}
	 if Port == 'ERROR' then
	    {Out.'ERROR' Msg}
	 else
	    {SendOut Out Msg}
	 end
	 Ack = ack
      end
   end
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
		   inPorts(input)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp} IP IPF C Name in
				IP = {Ins.input.get}
			       % Unique name
				Name = {VirtualString.toAtom "comp"#@Unique}
				Unique := @Unique + 1
			       % Transform int in float
				IPF = create(button:IP.button x:{Int.toFloat IP.x} y:{Int.toFloat IP.y} name:Name)
				C = {SubComp.new Name "editor/component" "./components/editor/component.fbp"}
				{Wait C}
			       % Bind the port of the new component and start it
				{C bind(out {OutPortWrapper Out} out)}
				{C bind('ERROR' {OutPortWrapper Out} 'ERROR')}
				{C send('in' IPF _)}
				{C start}
			     end)
		   )
      }
   end
end