functor
import
   GraphM at './lib/graph.ozf'
   Application
define
   Args = {Application.getArgs plain}
   G = {GraphM.loadGraph Args.1}
   {GraphM.start G}
end
