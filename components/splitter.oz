functor
export
   Component
define
   Component = comp(description:"splitter"
		    inPorts(input)
		    outArrayPorts(out)
		    procedure(proc {$ Ins Out Comp} I in
				 I = {Ins.input.get}
				 {FoldL I fun {$ Acc IP} N in
					      N = {String.toAtom {Int.toString Acc}}
					      {Out.out.N IP}
					      Acc+1
					   end 1 _}
			      end)
		   )
end