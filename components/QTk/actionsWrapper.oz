functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:actionsWrapper
		   inPorts('in')
		   outArrayPorts(action)
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
				if {Label IP} == getEntryPoint then R in
				   R = {Record.make IP.output [1]}
				   R.1 = Comp.entryPoint
				   {QTkHelper.sendOut Out R}
				else
				   {QTkHelper.sendOut Out IP}
				end
			     end)
		   )
      }
   end
end