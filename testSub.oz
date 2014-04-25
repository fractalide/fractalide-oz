functor
import
   Sub at './lib/subcomponent.ozf'
   Disp at './components/display.ozf'
   Application
define
   Args = {Application.getArgs plain}
   G = {Sub.new app test Args.1}
   D = {Disp.new display}
   {G bind('ERROR' D input)}
   {D send(options opt(pre:error) _)}
   
   {G start}
end
