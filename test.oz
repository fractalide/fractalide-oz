declare
[Generator] = {Module.link ['./components/generator.ozf']}
[Display] = {Module.link ['./components/display.ozf']}
D = {Display.new}
D2 = {Display.newArgs r(pre:'the number is ' post:' says the second displayer')}
G = {Generator.new}
{G bind(output D input)}
{G bind(output D2 input)}
{G start}

{D send(options r(pre:'the number is' post:'.'))}

{G stop}