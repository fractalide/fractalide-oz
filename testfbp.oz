declare
[Graph] = {Module.link ["./lib/graph.ozf"]}
G = {Graph.loadGraph "test.fbp"}

{G.gen start}
{G.gen2 start}

{G.gen stop}

{G.gen2 stop}