functor
import
   Browser
   Generator at './components/generator.ozf'
   Display at './components/display.ozf'
define
   D = {Display.new}
   D2 = {Display.newArgs r(pre:'the number is ' post:' says the second displayer')}
   G = {Generator.new}
   {G bind(output D input)}
   {G bind(output D2 input)}
   {Browser.browse 'Graph started for 20 seconds'}
   {G start}
   {Delay 10000}
   {D send(options r(pre:'the number is' post:'.'))}
   {Delay 10000}
   {G stop}
   {Browser.browse 'Graph stoped'}
end