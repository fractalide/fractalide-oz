declare
[Comp] = {Module.link ["./lib/component.ozf"]}
fun {Load Name}
   C in
   [C] = {Module.link ["./components/"#Name#".ozf"]}
   {C.new}
end
C = {Load count}
D = {Load display}
{Comp.bind C.outPorts.out D.inPorts.inp}
{Send C.inPorts.inp begin}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp 'end'}
{Send C.inPorts.inp begin}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp 'end'}
{Send C.inPorts.inp begin}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp data(a)}
{Send C.inPorts.inp 'end'}