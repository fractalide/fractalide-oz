functor
import
   Comp at '../lib/component.ozf'
export
   new: NewNand
define
   fun {NewNand Name}
      {Comp.new comp(name:Name type:string
		     inPorts(
			input: proc{$ Buffer Out NVar State Options} Msg in
				  Msg = {Buffer.get}
				  if {List.member 1 {Arity Options.text}} then
				     {Out.out Options.text}
				  else R in
				     R = {Record.make Options.text [1]}
				     R.1 = Msg
				     {Out.out R}
				  end
			       end
			)
		     outPorts(out)
		     options(text:_)
		    )
      }
   end
end