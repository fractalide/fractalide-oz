functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
   newSpec: CompNewGen
   sendOut: SendOut
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.e}} then
	 {OutPorts.e.{Label Event} Event}
      else
	 {OutPorts.eo Event}
      end
   end
   fun {CompNewGen Name Catch}
      {Comp.new comp(
		   name:Name type:simpleui
		   inPorts(
		      events: proc{$ Buf Out NVar State Options} IP Res in
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
		   outArrayPorts(e)
		   outPorts(eo)
		   options(handle:_) 
		   )
      }
   end
   fun {CompNewArgs Name}
      Catch = fun {$ IP BufPut Out NVar State Options}
		 some(IP)
	      end
   in
      {CompNewGen Name Catch}
   end
end