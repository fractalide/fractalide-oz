functor
import
   Browser
   Graph at './lib/graph.ozf'
define
   G = {Graph.loadGraph "test2.fbp"}
   {Browser.browse 'The graph is started for 20 seconds'}
   {Graph.start G}
   {Delay 20000}
   {Graph.stop G}
   {Browser.browse 'The graph is stopped'}
end

