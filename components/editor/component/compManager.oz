functor
import
   CompLib at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {OutPortWrapper Out} 
      proc{$ send(N Msg Ack)}
	 {Out.N Msg}
	 Ack = ack
      end
   end
   fun {CompNewGen Name}
      {CompLib.new comp(
		      name:Name type:'components/editor/component/compManager'
		      inPorts('in')
		      outPorts(out image)
		      procedure(proc{$ Ins Out Comp} {InputProc Ins.'in' Out Comp} end)
		      state(comp:_)
		      )
      }
      
   end
   proc{InputProc In Out Comp} IP in
      IP = {In.get}
      case {Label IP}
      of create then
	 Comp.state.comp := {CompLib.new comp(name:{VirtualString.toAtom IP.name}
					      type:dummy)}
	 {Comp.state.comp bind('ERROR' {OutPortWrapper Out} out)}
      [] createLink then 
	 {Out.out {Record.adjoinList IP [comp#Comp.state.comp entryPoint#Comp.parentEntryPoint]}}
      [] newComp then State Type in
         % Delete old port
	 {Out.out delete}
	 % Stop the old com
	 {Comp.state.comp stop}
	 % Bind error port
	 {IP.1 bind('ERROR' {OutPortWrapper Out} out)}
	 % Replace the entry point
	 Comp.state.comp := IP.1
	 State = {IP.1 getState($)}
	 Type = {Atom.toString State.type}
	 if Type.1 == "Q".1 andthen Type.2.1 == "T".1 andthen Type.2.2.1 == "k".1 andthen Type.2.2.2.1 == "/".1 then
	    {Out.image photo(file:"./components/editor/images/circle_blue.gif")}
	 else
	    {Out.image photo(file:"./components/editor/images/circle.gif")}
	 end
      [] start then
	 {Comp.state.comp start}
      [] stop then
	 {Comp.state.comp stop}
      [] delete then
	 Comp.state.comp := nil
      [] displayObj then
	 {Out.out displayComp(
		     1:Comp.parentEntryPoint
		     2:Comp.state.comp)}
      [] options then Ack in
	 {Comp.state.comp send(options IP Ack)}
	 {Wait Ack}
      [] nameChange then S NS in
	 S = {Comp.state.comp getState($)}
	 NS = {Record.adjoinAt S name {VirtualString.toAtom IP.1}}
	 {Comp.state.comp setState(NS)}
      end
   end
end