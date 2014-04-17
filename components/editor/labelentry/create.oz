functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/labelentry/create'
		   inPorts(
		      ui_in(proc{$ In Out Comp}
			       {Out.ui_out {Record.adjoin r(width:10 bg:white) {In.get}}}
			    end)
		      )
		   outPorts(ui_out)
		   )
      }
   end
end