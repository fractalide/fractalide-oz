functor
import
   Comp at '../../../lib/component.ozf'
   SubComp at '../../../lib/subcomponent.ozf'
   GridComp at '../../QTk/grid.ozf'
export
   new: CompNewGen
define
   fun {OutPort Out} 
      proc{$ send(_ Msg Ack)}
	 {Out.out Msg}
	 Ack = ack
      end
   end
   fun {OutPortGrid Grid Row} 
      proc{$ send(_ Msg Ack)}
	 {Grid send('in' configure(Msg.1 column:3 row:Row) Ack)}
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/displayOptionsEdit'
		   inPorts(input)
		   outPorts(out)
		   procedure(proc{$ Ins Out Comp} {InputProc Ins.input Out Comp} end)
		   )
      }
   end
   proc{InputProc In Out Comp} IP Grid A1 A2 A3 in
      IP = {In.get}
			       % Create the grid component
      Grid = {GridComp.new grid}
      {Grid bind(out {OutPort Out} nil)}
      {Grid addinArrayPort(grid '1x1')}
      {Grid send('in' create(bg:white) A1)}
      {Wait A1}
			       % send to grid#1 to initialize the grid
      {Grid send(grid#'1x1' create(label(text:"no option" bg:white)) A3)}
      {Wait A3}
			       % If there is options :
      if {Label IP.1} == component andthen {Record.width IP.1.options} > 0 then Opt in
	 Opt = IP.1.options 
	 {Grid send('in' configure(label(text:"options:" bg:white) column:1 columnspan:3 row:1 sticky:we) A2)}
	 {Wait A2}
                               % The options of the comp
	 {Record.foldLInd Opt
	  fun{$ Ind Acc Val} EV Ack Ack2 Ack3 I V in
			       	   % Create the editValue widget
	     EV = {SubComp.new value "editor/editPanel/editValue" "./components/editor/editPanel/editValue.fbp"}
	     {EV bind(out {OutPortGrid Grid Acc} nil)}
	     {EV bind(newvalue {OutPort Out} nil)}
	     {EV start}
	     I = {Value.toVirtualString Ind 50 50}
	     V = {Value.toVirtualString Val 50 50}
	     {EV send('in' create(I#V) Ack)}
	     {Wait Ack}
			       	   % Send out the label
	     {Grid send('in' configure(label(text:{Atom.toString Ind} bg:white) column:1 row:Acc) Ack2)}
	     {Wait Ack2}
	     {Grid send('in' configure(label(text:":" bg:white) column:2 row:Acc) Ack3)}
	     {Wait Ack3}
	     Acc+1
	  end
	  2
	  _
	 }
      end
   end
end