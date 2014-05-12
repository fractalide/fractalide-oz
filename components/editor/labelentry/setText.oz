functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name} 
      {Comp.new comp(
		   name:Name type:'components/editor/labelentry/create'
		   inPorts(input)
		   outPorts(output textchange)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.input.get}
				{Out.output set(text:IP.1)}
				{Out.output display}
				{Out.textchange textChanged(IP.1)}
			     end)
		   )
      }
   end
end