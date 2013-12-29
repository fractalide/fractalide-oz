functor
import
   Browser
   Not at './components/not.ozf'
   And at './components/and.ozf'
   Or at './components/or.ozf'
   Nor at './components/nor.ozf'
   Disp at './components/display.ozf'
define
   {Browser.browse 'creation of gates'}
   N = {Not.new}
   A = {And.new}
   O = {Or.new}
   No = {Nor.new}
   D = {Disp.new}
   {Delay 500}
   
   {Browser.browse 'link to display'}
   {N bind(out D input)}
   {A bind(out D input)}
   {O bind(out D input)}
   {No bind(out D input)}
   {Delay 500}
   
   {Browser.browse 'Test NOT, once with 1, once with 0'}
   {N send(x 1 _)}
   {N send(x 0 _)}
   {Delay 500}
   
   {Browser.browse 'Test AND, with 1 and 1'}
   {A send(x 1 _)}
   {A send(y 1 _)}
   {Delay 500}
   
   {Browser.browse 'Test AND, with 0 and 1'}
   {A send(x 0 _)}
   {A send(y 1 _)}
   {Delay 500}
   
   {Browser.browse 'Test OR, with 0 and 1'}
   {O send(x 0 _)}
   {O send(y 1 _)}
   {Delay 500}
   
   {Browser.browse 'Test NOR, with 0 and 1'}
   {No send(x 0 _)}
   {No send(y 1 _)}
end   
