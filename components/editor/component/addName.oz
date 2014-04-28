functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:"editor/component/addName"
		   inPorts(
		      input(proc{$ In Out Comp} IP NewName in
			       IP = {In.get}
			       NewName = Comp.options.name#IP.name
			       {Out.output {Record.adjoinAt IP
					    name NewName}}
			    end)
		      )
		   outPorts(output)
		   options(name:_)
		   )
      }
   end
end