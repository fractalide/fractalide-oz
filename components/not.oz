functor
import
   Graph at '../lib/graph.ozf'
   SubComp at '../lib/subcomponent.ozf'
export
   new: SubCompNew
define
   fun {SubCompNew} 
      G = {Graph.loadGraph "./components/not.fbp"}
      S = {SubComp.new G}
      {S renameInPort(sep_input x)}
      {S renameOutPort(nand_out out)}
   in
      S
   end
end
      
   
