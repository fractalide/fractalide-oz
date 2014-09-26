functor
import
   QTk at 'x-oz://system/wp/QTk.ozf'
export
   Component
define
   Component = component(
		  description:"The QTk image"
		  outPorts(output)
		  inPorts(input)
		  procedure(proc {$ Ins Out Comp} NOptions in
			       NOptions = {Record.adjoin {Ins.input.get} photo}
			       {Out.output {QTk.newImage NOptions}}
			    end)
		  )
end
     