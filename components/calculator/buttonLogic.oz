functor
import
   Comp at '../../lib/component.ozf'
   OS
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:buttonLogic
		     inPorts(input: proc {$ Buf Out NVar State Options}
				       IP = {Buf.get}
				    in
				       if Options.ctrl andthen Options.maj then Color in
					  Color = c(({OS.rand} mod 255) ({OS.rand} mod 255) ({OS.rand} mod 255))
					  {Out.color set(bg:Color activebackground:Color)}
				       else
					  {Out.click IP}
				       end
				    end)
		     outPorts(click color)
		     options(maj:false ctrl:false)
		    )
      }
   end
end