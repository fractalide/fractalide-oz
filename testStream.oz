functor
import
   Adder at 'components/add2.ozf'
   Display at 'components/display.ozf'
   Browser
define
   A = {Adder.new adder}
   D = {Display.new display}
   {A addinArrayPort(add 1)}
   {A addinArrayPort(add 2)}
   {A bind(output D input)}
   
   {A send(mul 1 _)}
   {A send(mul 2 _)}
   
   {A send(add#1 begin _)}
   {A send(add#1 1 _)}
   {A send(add#1 2 _)}
   {A send(add#1 'end' _)}
   {A send(add#2 begin _)}
   {A send(add#2 1 _)}
   {A send(add#2 2 _)}
   {A send(add#2 3 _)}
   {A send(add#2 'end' _)}
   
   {Browser.browse 'wait 3 sec to send the options'}
   {Delay 3000}
   {A send(options opt(operation:add) _)}
   {A send(options opt(operation:mul) _)}
   {Browser.browse 'wait 1 sec after options change'}
   {Delay 1000}
   
   {A send(add#1 begin _)}
   {A send(add#1 11 _)}
   {A send(add#1 12 _)}
   {A send(add#1 'end' _)}
   {A send(add#2 begin _)}
   {A send(add#2 11 _)}
   {A send(add#2 12 _)}
   {A send(add#2 13 _)}
   {A send(add#2 'end' _)}

end