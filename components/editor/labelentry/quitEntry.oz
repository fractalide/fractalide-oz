functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/labelentry/create'
		   inPorts(
		      input(proc{$ In Out Comp} IP in
			       IP = {In.get}
			       if {Label IP} == 'KeyPress' andthen IP.key == 36 then
				  {Out.change get(output:getText)}
			       elseif {Label IP} == 'KeyPress' andthen IP.key == 9 then
				  {Out.esc display}
			       end
			    end)
		      )
		   outPorts(change esc)
		   )
      }
   end
end