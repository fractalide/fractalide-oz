/*
Add all the elements of streams received in the arrayPort, and multiply the result by the IP received in mul.
*/
functor
import
   Comp at '../lib/component.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs}
      {Comp.new comp(
		   inPorts(
		      mul: proc{$ Buf Out NVar State Options}
			      NVar.mul = {Buf.get}
			   end)
		   inArrayPorts(add: proc{$ Buffers Out NVar State Options}
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
				     NVar.add = {FoldL Buffers fun{$ Acc Buffer} Acc+{AddStream Buffer} end 0}
				  end)
		   procedures(proc {$ Out NVar State Options}
				 if Options.operation == 'mul' then
				    {Out.output NVar.mul*NVar.add}
				 else
				    {Out.output NVar.mul+NVar.add}
				 end
			      end)
		   outPorts(output)
		   var(mul add)
		   options(operation:_)
		   )}
   end
end