functor
import
   %Browser
   System
   Property
export
   Component
define
   {Property.put print foo(width:20 depth:20)}
   Component = comp(description:"Display Option.pre#IP#Option.post and send the IP on the output port"
		    inPorts(input 'HALT')
		    outPorts(output)
		    options(pre:'' post:'')
		    procedure(
		       proc{$ Ins Out Comp} IP in
			  if {Ins.input.size} > 0 then 
			     IP = {Ins.input.get}
			     {System.show Comp.options.pre#IP#Comp.options.post}
			     {Out.output IP}
			  end
			  if {Ins.'HALT'.size} > 0 then
			     {System.show haltDisplay}
			  end
		       end
		       )
		   )
end