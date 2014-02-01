functor
import
   Adder at 'components/add2.ozf'
   Display at 'components/display.ozf'
define
   A = {Adder.new}
   D = {Display.new}
   {A addinArrayPort(add)}
   {A addinArrayPort(add)}
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