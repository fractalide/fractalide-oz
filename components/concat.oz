functor
import
   Comp at '../lib/component.ozf'
export
   new: NewConcat
define
   fun {NewConcat Name}
      {Comp.new comp(name:Name type:concat
		     inArrayPorts(input)
		     outPorts(out)
		     procedure(proc {$ Ins Out Comp}
					    Tab = {Record.map Ins.input fun {$ El} {El.get} end}
					 in
					    {Out.out Tab}
					 end)
		    )
      }
   end
end