/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:add2
		   inPorts(
		      mul(proc{$ Buf Out Comp}
			     Comp.var.mul = {Buf.get}
			  end)
		      )
		   inArrayPorts(add(proc{$ Buffers Out Comp}
				     fun {AddStream Buffer}
					fun {AddStreamRec Acc} IP in
					   IP = {Buffer.get}
					   case IP
					   of begin then {AddStreamRec 0}
					   [] 'end' then Acc
					   else
					      thread {AddStreamRec IP+Acc} end
					   end
					end
				     in
					thread {AddStreamRec 0} end
				     end
				  in
				     Comp.var.add = {FoldL Buffers fun{$ Acc Buffer} Acc+{AddStream Buffer} end 0}
				    end)
				)
		   procedures(proc {$ Out Comp}
				 if Comp.options.operation == 'mul' then
				    {Out.output Comp.var.mul*Comp.var.add}
				 else
				    {Out.output Comp.var.mul+Comp.var.add}
				 end
			      end)
		   outPorts(output)
		   var(mul add)
		   options(operation:_)
		   )}
   end
end