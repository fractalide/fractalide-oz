functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:dndLogic
		     inPorts(input(proc{$ In Out Comp}
				      IP = {In.get}
				   in

				      if {Label IP} == 'ButtonPress' andthen IP.button == 3 then
					    {Out.output opt(text:beginLink(x:IP.x y:IP.y entryPoint:_))}
				      end
				   end)
			    )
		     outPorts(output)
		    )
      }
   end
end