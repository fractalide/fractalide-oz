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
		      inPorts(input)
		      outPorts(output)
		      procedure(proc{$ Ins Out Comp} Type in
				   _ = {Ins.input.get}
				   Type = {QTk.dialogbox load(initialdir:"." 
							      title:"Which component?"
							      $)}
				   {Out.output dummyName#Type}
				end)
		      )
      }
   end
end