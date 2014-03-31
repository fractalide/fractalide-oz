functor
import
   Comp at '../../lib/component.ozf'
   Qtk at 'x-oz://system/wp/QTk.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:simpleui
		   inPorts(
		      ui: proc{$ Buf Out NVar State Options} IP H in
			     IP = {Buf.get}
			     H = IP.handle
			     H = {Qtk.build {Record.subtract IP handle}}
			     {H show}
			     {H {Record.adjoin Options set}}
			  end
		      )
		   )
      }
   end
end