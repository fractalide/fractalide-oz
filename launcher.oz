functor
import
   Fractalide at './lib/fractalide.ozf'
   Application
define
   Args = {Application.getArgs plain}
   G = {Fractalide.load test {VirtualString.toAtom Args.1}}
   D = {Fractalide.load disp display}
   F = {Fractalide.load five 'failure/five'}
   {G bind('ERROR' F input)}
   {F bind(output D input)} % Bind normal message
   {F bind('ERROR' D input)} % Bind error of the failure component...
   {D send(options opt(pre:error) _)}
   
   {G start}
end
