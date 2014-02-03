functor
import
   GraphM at './lib/graph.ozf'
define
   G = {GraphM.loadGraph "testGates.fbp"}
   {GraphM.start G}
end
