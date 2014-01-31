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
   fun {CompNewArgs Args} Options in
      Options = {Record.adjoinList options(pre:'' post:'') {Record.toListInd Args}}
      {Comp.new comp(
                 inPorts(
                 port(name:input
                         procedure: FunPort1)
                 )
                 outPorts(output:port)
                 Options
                 )
      }
   end
   fun {CompNew}
      {CompNewArgs r()}
   end
end