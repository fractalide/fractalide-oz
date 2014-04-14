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
		   name:Name type:simpleui
		   inPorts(
		      actions_in: proc{$ Buf Out NVar State Options} IP in
				     IP = {Buf.get}
				     case {Label IP}
				     of display then {SendOut Out set(Options.handlePH)}
				     [] getHandle then R in
					R = {Record.make IP.output [1]}
					R.1 = Options.handle
					{SendOut Out R} 
				     else
					if {HasFeature IP output} then Res Get L in
					   Get = {Record.subtract IP output}
					   L = if {Record.width Get} == 0 then [1] else {Record.toList Get} end
					   Res = {Record.make IP.output
						  L
						 }
					   try
					      {Options.handle {Record.adjoin Res {Label IP}}}
					      {SendOut Out Res}
					   catch _ then
					      {SendOut Out IP}
					   end
					else
					   try {Options.handle IP}
					   catch _ then
					      {SendOut Out IP}
					   end
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
end