functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createLinkLogic'
		   inPorts(comp pos)
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp} Comp Pos in
				Comp = {Ins.comp.get}
				Pos = {Ins.pos.get}.1
				{Out.out {Record.adjoin createLink(x:Pos.1 y:Pos.2.1) Comp}}
			     end)
		   )
      }
   end
end