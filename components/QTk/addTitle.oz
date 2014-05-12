functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:'QTk/addTitle'
		     inPorts(input)
		     outPorts(output)
		     procedure(proc{$ Ins Out Comp} IP in
				  IP = {Ins.input.get}
				  {Out.output create({Record.adjoinAt IP.1 title Comp.options.title})}
			       end)
		     options(title:_)
		    )
      }
   end
end