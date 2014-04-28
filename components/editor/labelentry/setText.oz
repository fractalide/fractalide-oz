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
		      input(proc{$ In Out Comp}
			       {Out.output set(text:{In.get}.1)}
			       {Out.output display}
			       {Out.textchange textChanged({In.get}.1)}
			    end)
		      )
		   outPorts(output textchange)
		   )
      }
   end
end