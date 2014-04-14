functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:ipEdit
		     inPorts(
			input(proc{$ Buffer Out Comp} Msg NMsg in
				  Msg = {Buffer.get}
				  NMsg = {Record.map Comp.options.text
					  fun {$ E} if {IsDet E} then E else Msg end end}
				  {Out.out NMsg}
			       end)
			)
		     outPorts(out)
		     options(text:_)
		    )
      }
   end
end