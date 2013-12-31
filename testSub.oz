functor
import
   Browser
   GraphM at './lib/graph.ozf'
define
   G = {GraphM.loadGraph "testGates.fbp"}

   {Browser.browse 'Nand with 0 1'}
   {G.'nand'.comp send(x 0 _)}
   {G.'nand'.comp send(y 1 _)}

   {Delay 500}
   {Browser.browse 'Nand with 1 1'}
   {G.'nand'.comp send(x 1 _)}
   {G.'nand'.comp send(y 1 _)}

   {Delay 500}
   {Browser.browse 'Not with 0 then 1'}
   {G.'not'.comp send(x 0 _)}
   {Delay 500}
   {G.'not'.comp send(x 1 _)}

   {Delay 500}
   {Browser.browse 'And with 0 1'}
   {G.'and'.comp send(x 0 _)}
   {G.'and'.comp send(y 1 _)}

   {Delay 500}
   {Browser.browse 'And with 1 1'}
   {G.'and'.comp send(x 1 _)}
   {G.'and'.comp send(y 1 _)}

   {Delay 500}
   {Browser.browse 'or With 0 0'}
   {G.'or'.comp send(x 0 _)}
   {G.'or'.comp send(y 0 _)}

   {Delay 500}
   {Browser.browse 'or with 0 1'}
   {G.'or'.comp send(x 0 _)}
   {G.'or'.comp send(y 1 _)}

   {Delay 500}
   {Browser.browse 'nor with 0 1'}
   {G.'nor'.comp send(x 0 _)}
   {G.'nor'.comp send(y 1 _)}
end