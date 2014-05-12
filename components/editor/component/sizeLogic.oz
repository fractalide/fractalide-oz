functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/component/sizeLogic'
		   inPorts(input)
		   procedure(proc{$ Ins Out Comp} Changed in
				{InputProc Ins.input Out Comp Changed}
				if Changed then C HComp HL HR HMax H2 X Y X2 Y2 in
				   C = Comp.state.comp
				   HL = Comp.state.left.height
				   HR = Comp.state.right.height
				   HMax = if HL > HR then HL else HR end
				   HComp = C.4-C.2
				   H2 = if HComp > HMax then 0.0 else (HMax-HComp)/2.0 end
				   X = C.1 - Comp.state.right.width
				   Y = C.2 - H2
				   X2 = C.3 + Comp.state.left.width
				   Y2 = C.4 + H2
				   {Out.newPos setCoords(X Y X2 Y2)}
				end
			     end)
		   outPorts(newPos)
		   state(comp:comp(0.0 0.0 0.0 0.0) 
			 left:left(width:0.0 height:0.0)
			 right:right(width:0.0 height:0.0)
			)
		   )
      }
   end
   proc{InputProc In Out Comp Changed} IP in
      IP = {In.get}
      case {Label IP}
      of create then
	 Comp.state.comp := comp(IP.1 IP.2 IP.3 IP.4)
	 Changed = false
      [] move then C X Y in
	 X = {Int.toFloat IP.1}
	 Y = {Int.toFloat IP.2}
	 C =  Comp.state.comp
	 Comp.state.comp := comp(C.1+X C.2+Y C.3+X C.4+Y)
	 Changed = false
      [] left then 
	 Comp.state.left := IP
	 Changed = true
      [] right then
	 Comp.state.right := IP
	 Changed = true
      else Changed = false
      end
   end
end