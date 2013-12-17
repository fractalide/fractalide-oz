declare
[Generator] = {Module.link ['./components/generator.ozf']}
[Display] = {Module.link ['./components/display.ozf']}
D = {Display.new}
G = {Generator.new}
{G bind(output D input)}
{G start}

{D send(options r(pre:'the number is' post:'.'))}

{G stop}