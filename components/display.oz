functor
import
   Browser
   Comp at '../lib/component.ozf'
export
   new: CompNew
   newArgs: CompNewArgs
define
   proc {FunPort1 Buffer Out NVar State Options}
      IP = {Buffer.get}
   in
      {Browser.browse Options.pre#IP#Options.post}
      {Out.output IP}
   end
   fun {CompNewArgs Name Args} Options in
      Options = {Record.adjoinList options(pre:'' post:'') {Record.toListInd Args}}
      {Comp.new comp(description:"Display Option.pre#IP#Option.post and send the IP on the output port"
		   name:Name type:display
		   inPorts(input: FunPort1)
		   outPorts(output)
		   Options
		   )
      }
   end
   fun {CompNew Name}
      {CompNewArgs Name r()}
   end
end