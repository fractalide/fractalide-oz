functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/labelentry/create'
		   inPorts('in')
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp}
			       {Out.out {Record.adjoin create(width:10 bg:white) {Ins.'in'.get}}}
			    end)
		   )
      }
   end
end