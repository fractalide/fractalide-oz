functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:ipEdit
		     inPorts(input)
		     outPorts(out)
		     procedure(proc{$ Ins Out Comp} Msg NMsg in
				  Msg = {Ins.input.get}
				  NMsg = {Record.map Comp.options.text
					  fun {$ E} if {IsDet E} then E else Msg end end}
				  {Out.out NMsg}
			       end)
		     options(text:_)
		    )
      }
   end
end