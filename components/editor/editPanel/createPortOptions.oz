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
		   procedure(proc{$ Ins Out Comp} IP FromS FromPorts ToS ToPorts in
				IP = {Ins.'in'.get}
				{Out.grid create(bg:white)}
				{Out.to create(init:IP.to)}
				{Out.'from' create(init:IP.'from')}

				% Create the lists
				FromS = {IP.fromComp getState($)}
				FromPorts = {Record.foldLInd FromS.outPorts
					     fun{$ I Acc P}
						if {Label P} == arrayPort then
						   {Atom.toString I}#"#" | Acc
						else
						   {Atom.toString I} | Acc
						end
					     end
					     nil
					    }
				{Out.listfrom FromPorts}
				ToS = {IP.toComp getState($)}
				ToPorts = {Record.foldLInd ToS.inPorts
					   fun{$ I Acc P}
						if {Label P} == arrayPort then
						   {Atom.toString I}#"#" | Acc
						else
						   {Atom.toString I} | Acc
						end
					     end
					     nil
					  }
				{Out.listto ToPorts}
			     end)
		   )
      }
   end
end