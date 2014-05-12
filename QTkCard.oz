functor
import
   Sub at './lib/subcomponent.ozf'
   Disp at './components/display.ozf'
   Five at './components/failure/five.ozf'
   Window at './components/QTk/window.ozf'
   Application
define
   Args = {Application.getArgs plain}
   G = {Sub.new app test Args.1}
   % Manage error
   D = {Disp.new display}
   F = {Five.new five}
   {G bind('ERROR' F input)}
   {F bind(output D input)} % Bind normal message
   {F bind('ERROR' D input)} % Bind error of the failure component...
   {D send(options opt(pre:error) _)}

   % Manage the window
   Win = {Window.new w}
   {G bind(out Win 'in')}
   D2 = {Disp.new display2}
   {Win bind(out D2 input)}
   {D2 send(options opt(pre:default) _)}

   
   {G start}
end
