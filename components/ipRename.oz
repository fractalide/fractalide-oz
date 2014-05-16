functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:ipEdit
		     inPorts('in')
		     outPorts(out)
		     procedure(proc{$ Ins Out Comp} Msg in
				  Msg = {Ins.'in'.get}
				  {Out.out {Record.adjoin Msg Comp.options.name}}
			       end)
		     options(name:_)
		    )
      }
   end
end