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
		   inPorts('in')
		   inArrayPorts(grid)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				{Record.forAllInd Ins.grid
				 proc{$ Name In}
				    if {In.size} > 0 then {GridProc Name Ins.grid Out Comp} end
				 end}
			     end)
		   state(handle:_ buffer:nil)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP grid(handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Comp.entryPoint}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{GridProc Sub Ins Out Comp} IP in
       IP = {Ins.Sub.get}
       case {Label IP}
       of create then C NIP in
	  C = {Split Sub "x"}
	  NIP = if {HasFeature IP.1 glue} then
		   {Record.adjoin create({Record.subtract IP.1 glue}) configure(row:C.row column:C.column sticky:IP.1.glue)}
		else
		   {Record.adjoin IP configure(row:C.row column:C.column)}
		end
	  {QTkHelper.manageIP NIP Out Comp}
       [] configure andthen Sub \= grid then C NIP in
	  C = {Split Sub "x"}
	  NIP = {Record.adjoin IP configure(row:C.row column:C.column)}
	  {QTkHelper.manageIP NIP Out Comp}
       else
	  {QTkHelper.manageIP IP Out Comp}
       end
    end
end