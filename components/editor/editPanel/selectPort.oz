functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/selectPort'
		   inPorts('in')
		   outPorts(out label)
		   options(name:_)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				if {Not {Reverse IP.element}.1 == "#".1} then
				   {Out.out {Record.adjoin a(IP.element) Comp.options.name}}
				   {Out.label set(IP.element)}
				else
				   {Out.label set(IP.element)}
				   {Out.label display}
				   {Out.label getFocus}
				end
			     end)
		   )
      }
   end
end