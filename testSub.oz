functor
import
   Sub at './lib/subcomponent.ozf'
   Disp at './components/display.ozf'
   Five at './components/failure/five.ozf'
   Application
define
   Args = {Application.getArgs plain}
   G = {Sub.new app test Args.1}
   D = {Disp.new display}
   F = {Five.new five}
   {G bind('ERROR' F input)}
   {F bind(output D input)} % Bind normal message
   {F bind('ERROR' D input)} % Bind error of the failure component...
   {D send(options opt(pre:error) _)}
   
   {G start}
end
