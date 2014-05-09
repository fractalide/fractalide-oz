functor
import
   Comp at '../../lib/component.ozf'
   QTkHelper
export
   new: CompNewArgs
define
   fun {GetNext List Sub}
      fun {Rec Ls After}
	 case Ls
	 of nil then After#all
	 [] L|Lr then
	    if Sub < L then After#L
	    else
	       {Rec Lr L}
	    end
	 end
      end
      A B
      After Before
   in
      A#B = {Rec {Arity List} nil}
      After = if A \= all andthen A \= nil then List.A else A end
      Before = if B \= all then List.B else B end
      After#Before
   end
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:'QTk/panel'
		   inPorts('in')
		   inArrayPorts(panel)
		   outPorts(out)
		   outArrayPorts(action)
		   procedure(proc{$ Ins Out Comp}
				if {Ins.'in'.size} > 0 then {InProc Ins.'in' Out Comp} end
				{Record.forAllInd Ins.panel
				 proc{$ Name Buf}
				    if {Buf.size} > 0 then  {PanelProc Name Ins.panel Out Comp} end
				 end}
			     end)
		   state(handle:_ buffer:nil list:h)
		   )}
   end
   proc{InProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then H B in
	 B = {Record.adjoin IP panel(handle:H)}
	 {Out.out create(B)}
	 {Wait H}
	 {QTkHelper.bindEvents H Out}
	 Comp.state.handle := H
	 {QTkHelper.feedBuffer Out Comp}
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
   proc{PanelProc Sub Ins Out Comp} IP in
      IP = {Ins.Sub.get}
      case {Label IP}
      of create then NIP After Before in
				  % delete if exists
	 if {HasFeature Comp.state.list Sub} then
	    {Comp.state.handle deletePanel(Comp.state.list.Sub)}
	 end
				  % create new one
	 After#Before = {GetNext Comp.state.list Sub}
	 NIP = if After \= nil then
		  {Record.adjoin IP addPanel(after:After before:Before)}
	       else
		  {Record.adjoin IP addPanel(before:Before)}
	       end
	 {QTkHelper.manageIP NIP Out Comp}
	 {Wait IP.1.handle}
	 Comp.state.list := {Record.adjoinAt Comp.state.list Sub IP.1.handle}
      [] delete then NIP in
	 if {HasFeature Comp.state.list Sub} then
	    NIP = deletePanel(Comp.state.list.Sub)
	    {QTkHelper.manageIP NIP Out Comp}
	    Comp.state.list := {Record.subtract Comp.state.list Sub}
	 else
	    raise panel_not_exists(Sub) end
	 end
      else
	 {QTkHelper.manageIP IP Out Comp}
      end
   end
end