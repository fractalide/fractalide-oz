functor
import
   Graph at '../lib/graph.ozf'
   SubComp at '../lib/subcomponent.ozf'
export
   new: SubCompNew
define
   fun {SubCompNew} 
      G = {Graph.loadGraph "./components/nor.fbp"}
      S = {SubComp.new G}
      {S renameInPort(or_x x)}
      {S renameInPort(or_y y)}
      {S renameOutPort(not_out out)}
   in
      S
   end
end
      
