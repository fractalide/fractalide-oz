functor
import
   Browser
   Graph at './lib/graph.ozf'
define
   G = {Graph.loadGraph "test.fbp"}
   {Browser.browse 'The graph is started for 20 seconds'}
   {Graph.start G}
   Gen = {G.sub.comp getState($)}
   {Browser.browse {Gen.graph.gen.comp getState($)}}
   {Delay 20000}
   {Graph.stop G}
   {Browser.browse 'The graph is stoped'}
end

