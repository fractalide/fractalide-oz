functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(name:Name type:'QTk/addTitle'
		     inPorts(input(proc{$ In Out Comp} IP in
				      IP = {In.get}
				      {Out.output create({Record.adjoinAt IP.1 title Comp.options.title})}
				   end))
		     outPorts(output)
		     options(title:_)
		    )
      }
   end
end