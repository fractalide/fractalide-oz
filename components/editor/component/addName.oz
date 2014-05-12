functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/addName"
		   inPorts(input)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} IP NewName in
				IP = {Ins.input.get}
				NewName = Comp.options.name#IP.name
				{Out.output {Record.adjoinAt IP
					     name NewName}}
			     end)
		   options(name:_)
		   )
      }
   end
end