functor
import
   Comp at '../../../lib/component.ozf'
   SubComp at '../../../lib/subcomponent.ozf'
export
   new: CompNewGen
define
   fun {OutPortPH Out} 
      proc{$ send(_ Msg Ack)}
	 if {Label Msg} == placeholder then
	    {Out.ph set(Msg)}
	 else
	    {Out.ph Msg}
	 end
	 Ack = ack
      end
   end
   fun {OutPortGrid Grid Row} 
      proc{$ send(_ Msg Ack)}
	 {Grid send(actions_in configure(Msg column:3 row:Row) Ack)}
      end
   end
   fun {OutPortActions Out} 
      proc{$ send(_ Msg Ack)}
	 {Out.actions_out Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/displayOptionsEdit'
		   inPorts(
		      input(proc{$ In Out Comp} IP Grid A1 A2 A3 in
			       IP = {In.get}
			       % Create the grid component
			       Grid = {SubComp.new grid "ui/grid" "./components/ui/grid.fbp"}
			       {Grid bind(ui_out {OutPortPH Out} nil)}
			       {Grid bind(actions_out {OutPortPH Out} nil)}
			       {Grid addinArrayPort(grid 1)}
			       {Grid send(ui_in create(bg:white) A1)}
			       {Wait A1}
			       % send to grid#1 to initialize the grid
			       {Grid send(grid#1 label(text:"no option" bg:white) A3)}
			       {Wait A3}
			       % If there is options :
			       if {Label IP.1} == component andthen {Record.width IP.1.options} > 0 then Opt in
				  Opt = IP.1.options 
				  {Grid send(actions_in configure(label(text:"options:" bg:white) column:1 columnspan:3 row:1 sticky:we) A2)}
				  {Wait A2}
                               % The options of the comp
				  {Record.foldLInd Opt
				   fun{$ Ind Acc Val} EV Ack Ack2 Ack3 I V in
			       	   % Create the editValue widget
				      EV = {SubComp.new value "editor/editPanel/editValue" "./components/editor/editPanel/editValue.fbp"}
				      {EV bind(ui_out {OutPortGrid Grid Acc} nil)}
				      {EV bind(actions_out {OutPortActions Out} nil)}
				      {EV start}
				      I = {Value.toVirtualString Ind 50 50}
				      V = {Value.toVirtualString Val 50 50}
				      {EV send(ui_in I#V Ack)}
				      {Wait Ack}
			       	   % Send out the label
				      {Grid send(actions_in configure(label(text:{Atom.toString Ind} bg:white) column:1 row:Acc) Ack2)}
				      {Wait Ack2}
				      {Grid send(actions_in configure(label(text:":" bg:white) column:2 row:Acc) Ack3)}
				      {Wait Ack3}
				      Acc+1
				   end
				   2
				   _
				  }
			       end
			    end)
		      )
		   outPorts(ph actions_out)
		   )
      }
   end
end