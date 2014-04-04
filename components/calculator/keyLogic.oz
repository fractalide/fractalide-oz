functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:keyLogic
		     inPorts(input: proc {$ Buf Out NVar State Options}
				       IP = {Buf.get}
				    in
				       case {Label IP}
				       of 'KeyPress' then
					  if IP.key == 37 then
					     {Out.option opt(ctrl:true)}
					  elseif IP.key == 50 then
					     {Out.option opt(maj:true)}
					  end
				       [] 'KeyRelease' then
					  if IP.key == 37 then
					     {Out.option opt(ctrl:false)}
					  elseif IP.key == 50 then
					     {Out.option opt(maj:false)}
					  end
				       end
				       {Out.default IP} 
				    end
			     )
		     outPorts(default option)
		    )
      }
   end
end