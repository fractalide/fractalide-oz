functor
import
   Comp at '../../../lib/component.ozf'
export
   new: CompNewGen
define
   fun {CompNewGen Name}
      {Comp.new comp(
		   name:Name type:'components/editor/editPanel/createPortOptions'
		   inPorts('in')
		   outPorts(grid to 'from' listfrom listto)
		   procedure(proc{$ Ins Out Comp} IP FromPorts ToPorts in
				IP = {Ins.'in'.get}
				{Out.grid create(bg:white)}
				{Out.to create(init:IP.to)}
				{Out.'from' create(init:IP.'from')}
				FromPorts#ToPorts = {ComponentList IP.fromComp IP.toComp}
				{Out.listfrom FromPorts}
				{Out.listto ToPorts}
				
			     end)
		   )
      }
   end
   fun {ComponentList FromComp ToComp} FromS ToS FromPorts ToPorts in
      	% Create the lists
      FromS = {FromComp getState($)}
      {Wait FromS}
      FromPorts = {Record.foldLInd FromS.outPorts
		   fun{$ I Acc P} RealP in
		      RealP = if {Label FromS} == subcomponent then SubS in
				 SubS = {(P.1).1 getState($)}
				 SubS.outPorts.((P.1).2)
			      else P end
		      if {Label RealP} == arrayPort then
			 {Atom.toString I}#"#" | Acc
		      else
			 {Atom.toString I} | Acc
		      end
		   end
		   nil
		  }
      ToS = {ToComp getState($)}
      ToPorts = {Record.foldLInd ToS.inPorts
		 fun{$ I Acc P} RealP in
		    RealP = if {Label ToS} == subcomponent then SubS in
			       SubS = {(P.1).1 getState($)}
			       SubS.inPorts.((P.1).2)
			    else P end		    
		    if {Label RealP} == arrayPort then
		       {Atom.toString I}#"#" | Acc
		    else
		       {Atom.toString I} | Acc
		    end
		 end
		 nil
		}
      FromPorts#ToPorts
   end
end