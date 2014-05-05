functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {Split VS Sep}
      fun {Rec Acc Ls}
	 case Ls
	 of nil then raise separator_not_found(VS Sep) end
	 [] L|Lr then
	    if L == Sep.1 then X Y in
	       X = {String.toInt {Reverse Acc}}
	       Y = {String.toInt Lr}
	       coord(column:X row:Y)
	    else
	       {Rec L|Acc Lr}
	    end
	 end
      end
   in
      {Rec nil {Atom.toString VS}}
   end
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/grid'
		   asynchInArrayPorts(
		      actions_in(proc{$ Sub Ins Out Comp} IP in
				    IP = {Ins.Sub.get}
				    case {Label IP}
				    of create andthen Sub == grid then H B in
				       B = {Record.adjoin IP grid(handle:H)}
				       {Out.actions_out create(B)}
				       {Wait H}
				       {QTkHelper.bindEvents H Out}
				       Comp.state.handle := H
				       {QTkHelper.feedBuffer Out Comp}
				    [] create then C NIP in
				       C = {Split Sub "x"}
				       NIP = {Record.adjoin IP configure(row:C.row column:C.column)}
				       {QTkHelper.manageIP NIP Out Comp}
				    [] configure then C NIP in
				       C = {Split Sub "x"}
				       NIP = {Record.adjoin IP configure(row:C.row column:C.column)}
				       {QTkHelper.manageIP NIP Out Comp}
				    else
				       {QTkHelper.manageIP IP Out Comp}
				    end
				 end)
		      )
		   outPorts(actions_out)
		   outArrayPorts(action)
		   state(handle:_ buffer:nil)
		   )}
   end
end