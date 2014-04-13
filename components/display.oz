functor
import
   %Browser
   System
   Comp at '../lib/component.ozf'
export
   new: CompNew
   newArgs: CompNewArgs
define
   proc {FunPort1 IN Out Comp}
      IP = {IN.get}
   in
      %{Browser.browse Options.pre#IP#Options.post}
      {Delay 1000}
      {System.show Comp.options.pre#IP#Comp.options.post}
      {Out.output IP}
   end
   fun {CompNewArgs Name Args} Options in
      Options = {Record.adjoinList options(pre:'' post:'') {Record.toListInd Args}}
      {Comp.new comp(description:"Display Option.pre#IP#Option.post and send the IP on the output port"
		     name:Name type:display
		     inPorts(input(FunPort1))
		     outPorts(output)
		     Options
		    )
      }
   end
   fun {CompNew Name}
      {CompNewArgs Name r()}
   end
end