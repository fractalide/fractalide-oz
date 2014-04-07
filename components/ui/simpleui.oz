functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
   newSpec: CompNewGen
   sendOut: SendOut
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.actions_out Event}
      end
   end
   fun {CompNewGen Name Catch}
      {Comp.new comp(
		   name:Name type:simpleui
		   inPorts(
		      actions_in: proc{$ Buf Out NVar State Options} IP Res in
				     IP = {Buf.get}
				     Res = {Catch IP Buf.put Out NVar State Options}
				     if  {Label Res} == some then
					try {Options.handle Res.1}
					catch _ then
					   {SendOut Out Res.1}
					end
				     end
				  end
		      )
		   outArrayPorts(action)
		   outPorts(actions_out)
		   options(handle:_) 
		   )
      }
   end
   fun {CompNewArgs Name}
      Catch = fun {$ IP BufPut Out NVar State Options}
		 case {Label IP}
		 of display then some(set(Options.handle))
		 else
		    some(IP)
		 end
	      end
   in
      {CompNewGen Name Catch}
   end
end