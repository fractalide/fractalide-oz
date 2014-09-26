functor
import
   QTkHelper
export
   Component
define
   Component = comp(
		  description:"a basic QTk card"
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
end