functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNew
   newArgs: CompNewArgs
define
    fun {CompNewArgs Args} Options in
       Options = {Record.adjoinList options(arg:'') {Record.toListInd Args}}
      {Comp.new comp(
		   outPorts(output:port)
		   procedures(proc{$ Out NVar State Options}
				 {Out.output Options.arg}
			      end)
                 Options
                 )
      }
   end
   fun {CompNew}
      {CompNewArgs r()}
   end
end
      
   