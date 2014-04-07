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
		      actions_in: proc{$ Buf Out NVar State Options} 
				     {SendOut Out {Buf.get}}
				  end
		      )
		   outArrayPorts(action)
		   outPorts(actions_out)
		   )
      }
   end
end