functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
   newArgs: CompNewArgs
define
   fun {CompNewArgs Name Args} Options in
      Options = {Record.adjoinList options(arg:'') {Record.toListInd Args}}
      {Comp.new comp(name:Name type:genopt
		     outPorts(output)
		     procedures(proc{$ Out Comp}
				   {Out.output Comp.options.arg}
				end)
		     Options
		    )
      }
   end
   fun {CompNew Name}
      {CompNewArgs Name r()}
   end
end

   