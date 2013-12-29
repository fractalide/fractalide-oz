functor
import
   Graph at '../lib/graph.ozf'
   SubComp at '../lib/subcomponent.ozf'
export
   new: SubCompNew
define
   fun {SubCompNew} 
      G = {Graph.loadGraph "./components/and.fbp"}
      S = {SubComp.new G}
      {S renameInPort(nand_x x)}
      {S renameInPort(nand_y y)}
      {S renameOutPort(not_out out)}
   in
      S
   end
end
      
