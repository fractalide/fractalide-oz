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
		      actions_in(proc{$ In Out Comp} IP in
				     IP = {In.get}
				     case {Label IP}
				     of display then {SendOut Out set(Comp.options.handlePH)}
				     [] getHandle then R in
					R = {Record.make IP.output [1]}
					R.1 = Comp.options.handle
					{SendOut Out R} 
				     else
					if {HasFeature IP output} then Res ResArg Get L in
					   Get = {Record.subtractList IP [output set]}
					   L = if {Record.width Get} == 0 then [1] else {Record.toList Get} end
					   Res = {Record.make IP.output
						  L
						 }
					   ResArg = if {HasFeature IP arg} then
						       {Record.adjoin Res IP.arg}
						    else
						       Res
						    end
					   try
					      {Comp.options.handle {Record.adjoin ResArg {Label IP}}}
					      {SendOut Out ResArg}
					   catch _ then
					      {SendOut Out IP}
					   end
					else
					   try {Comp.options.handle IP}
					   catch _ then
					      {SendOut Out IP}
					   end
					end
				     end
				  end)
		      )
		   outArrayPorts(action)
		   outPorts(actions_out)
		   options(handle:_) 
		   )
      }
   end
end