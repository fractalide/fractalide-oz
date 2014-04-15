functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/join'
		   inPorts(
		      begin(proc{$ In Out Comp}
			       Comp.var.begin = {In.get}
			    end)
		      canvas(proc{$ In Out Comp}
				Comp.var.canvas = {In.get}.1
			     end)
		      )
		   procedures(proc{$ Out Comp}
				 {Out.output {Record.adjoinAt Comp.var.begin canvas Comp.var.canvas}}
			      end)
		   outPorts(output)
		   var(begin canvas)
		   )
      }
   end
end