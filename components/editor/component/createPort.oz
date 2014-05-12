functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/createPort'
		   inPorts('in')
		   outPorts(rect name)
		   procedure(proc{$ Ins Out Comp} IP in
				IP = {Ins.'in'.get}
			       case {Label IP}
			       of create then X Y in
				  {Out.rect {Record.subtractList IP [name]}}
				  X = (IP.1+IP.3)/2.0
				  Y = (IP.2+IP.4)/2.0
				  {Out.name create(X Y text:IP.name state:IP.state)}
			       end
			    end)
		   )
      }
   end
end