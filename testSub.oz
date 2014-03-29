functor
import
   GraphM at './lib/graph.ozf'
   Browser
define
   G = {GraphM.loadGraph "uiAdd.fbp"}
   %{Browser.browse G}
   {GraphM.start G}
   {Delay 500}
   {GraphM.startUI G}
end
