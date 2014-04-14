functor
import
   GraphM at './lib/graph.ozf'
   %Browser
define
   G = {GraphM.loadGraph "test.fbp"}
   %{Browser.browse G}
   {GraphM.start G}
end
