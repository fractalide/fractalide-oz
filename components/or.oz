functor
import
   Graph at '../lib/graph.ozf'
   SubComp at '../lib/subcomponent.ozf'
export
   new: SubCompNew
define
   fun {SubCompNew} 
      G = {Graph.loadGraph "./components/or.fbp"}
      S = {SubComp.new G}
      {S renameInPort(not1_x x)}
      {S renameInPort(not2_x y)}
      {S renameOutPort(nand_out out)}
   in
      S
   end
end
      
