functor
import
   GraphM at './lib/graph.ozf'
   Application
   Browser
define
   {Browser.browse a}
   {Delay 3000}
   Args = {Application.getArgs plain}
   G = {GraphM.loadGraph Args.1}
   {GraphM.start G}
end
