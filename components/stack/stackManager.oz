functor
import
   Comp at '../../lib/component.ozf'
export
   new: CompNew
define
   fun {CompNew Name}
      {Comp.new comp(name:Name type:stackManager
		     description:"maintain a stack of card"
		     inPorts('in')
		     inArrayPorts(card)
		     outPorts(out)
		     procedure(proc{$ Ins Out Comp}
				  if {Ins.'in'.size} > 0 then
				     {ManageIP {Ins.'in'.get} Out Comp}
				  end
				  {CardProc Ins Out Comp}
			       end)
		     state(stack:stack() actual:0)
		    )
      }
   end
   proc {CardProc Ins Out Comp}
      proc {Card Index} IP in
	 IP = {Ins.card.Index.get}
	 case {Label IP}
	 of create then
	    % save the creation
	    Comp.state.stack := {Record.adjoinAt Comp.state.stack Index IP}
	 else
	    {ManageIP IP Out Comp}
	 end
      end
   in
      % All selection work in an asynchronous way
      {Record.forAllInd Ins.card
       proc{$ Index Buf}
	  if {Buf.size} > 0 then {Card Index} end
       end
      }
   end
   proc{ManageIP IP Out Comp}
      proc {Change NIndex} Card NIP in
	 % Select the card at the index
	 Card = {List.nth {Record.toList Comp.state.stack} NIndex}
	 % Check if the first display
	 NIP = if {IsDet Card.1.handle} then set(Card.1.handle)
	       else {Record.adjoin Card set} end
	 % Display 
	 {Out.out NIP}
	 % Save the new position
	 Comp.state.actual := NIndex
      end
   in
      case {Label IP}
      of next then
	 % Don't go over the max width
	 {Change (Comp.state.actual mod {Record.width Comp.state.stack})+1}
      [] previous then NI in
	 % Don't go under 1
	 NI = if Comp.state.actual == 1 then {Record.width Comp.state.stack}
	      else Comp.state.actual - 1 end
	 {Change NI}
      [] goto then
	 {Change IP.1}
      else
	 {Out.out IP}
      end
   end
end

   