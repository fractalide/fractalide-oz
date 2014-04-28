functor
import
   CompLib at '../../../lib/component.ozf'
   QTk at 'x-oz://system/wp/QTk.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {CompLib.new comp(
		   name:Name type:'components/editor/component/compLoad'
		   inPorts(
		      input(proc{$ In Out Comp} Type in
			       _ = {In.get}
			       Type = {QTk.dialogbox load(initialdir:"." 
							  title:"Which component?"
							  $)}
			       {Out.output dummyName#Type}
			    end)
		      )
		   outPorts(output)
		   )
      }
   end
end