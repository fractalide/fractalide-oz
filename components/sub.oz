functor
import
   Graph at '../lib/graph.ozf'
   SubComp at '../lib/subcomponent.ozf'
export
   new: SubCompNew
define
   fun {SubCompNew} 
      G = {Graph.loadGraph "test2.fbp"}
      S = {SubComp.new G}
   in
      S
   end
end
      
   
