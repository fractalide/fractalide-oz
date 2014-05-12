functor
import
   %Browser
   System
   Comp at '../lib/component.ozf'
   Property
export
   new: CompNew
   newArgs: CompNewArgs
define
   {Property.put print foo(width:20 depth:20)}
   fun {CompNewArgs Name Args} Options in
      Options = {Record.adjoinList options(pre:'' post:'') {Record.toListInd Args}}
      {Comp.new comp(description:"Display Option.pre#IP#Option.post and send the IP on the output port"
		     name:Name type:display
		     inPorts(input)
		     outPorts(output)
		     Options
		     procedure(
			proc{$ Ins Out Comp} IP in
			   IP = {Ins.input.get}
			   {System.show Comp.options.pre#IP#Comp.options.post}
			   {Out.output IP}
			end
			)
		    )
      }
   end
   fun {CompNew Name}
      {CompNewArgs Name r()}
   end
end