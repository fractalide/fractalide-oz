functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:ipOrder
		     inArrayPorts('in')
		     outPorts(out)
		     procedure(proc{$ Ins Out Comp}
				  {Record.forAll Ins.'in'
				   proc{$ In}
				      {Out.out {In.get}}
				   end
				  }
			       end)
		    )
      }
   end
end