functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.actions_out Event}
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:actionsWrapper
		   inPorts(
		      actions_in(proc{$ Buf Out Comp} IP in
				    IP = {Buf.get}
				    if {Label IP} == getEntryPoint then R in
				    	R = {Record.make IP.output [1]}
				    	R.1 = Comp.entryPoint
				       {SendOut Out R}
				    else
				       {SendOut Out IP}
				    end
				 end)
		      )
		   outArrayPorts(action)
		   outPorts(actions_out)
		   )
      }
   end
end