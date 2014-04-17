functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
   System
export
   new: CompNewGen
define
   Unique = {NewCell 0}
   fun {OutPortWrapper Out} 
      proc{$ send(N Msg Ack)}
	 {System.show wrappercreatecomp#Msg}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/createComp'
		   inPorts(
		      input(proc{$ In Out Comp} IP IPF C Name in
			       IP = {In.get}
			       IPF = doubleclick(button:IP.button x:{Int.toFloat IP.x} y:{Int.toFloat IP.y})
			       Name = {VirtualString.toAtom "comp"#@Unique}
			       Unique := @Unique + 1
			       C = {SubComp.new Name "editor/component" "/home/denis/fractalide/fractallang/components/editor/component.fbp"}
			       {Wait C}
			       Comp.var.comp = C
			       Comp.var.init = IPF
			    end)
		      )
		   procedures(proc{$ Out Comp} C in
				 C = Comp.var.comp
				 {Wait C}
				 {C bind(ui_out {OutPortWrapper Out} widget_out)}
				 {C bind(actions_out {OutPortWrapper Out} actions_out)}
				 {C send(ui_in Comp.var.init _)}
				 {C start}
			      end)
		   var(comp init)
		   outPorts(widget_out actions_out)
		   )
      }
   end
end