functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createPortArray'
		   inPorts(
		      ui_in(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       case {Label IP}
			       of create then X Y in
				  {Out.rect {Record.subtractList IP [name]}}
				  X = (IP.1+IP.3)/2.0
				  Y = (IP.2+IP.4)/2.0
				  {Out.name create(X Y text:IP.name state:IP.state)}
				  {Out.nameAtom opt(name:{VirtualString.toAtom IP.name})}
			       end
			    end)
		      )
		   outPorts(rect name nameAtom)
		   )
      }
   end
end