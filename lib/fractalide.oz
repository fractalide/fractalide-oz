functor
import
   Open
   Module
   FBP at './fbpParser.ozf'
   Component at './component.ozf'
   SubComponent at './subcomponent.ozf'
export
   load: Load
   start: Start
   stop: Stop
define
   fun {Load Name Type}
      try C in
	 [C] = {Module.link ["./components/"#Type#".ozf"]}
	 {Component.new Name Type C.component}
      catch system(module(notFound load _)) then F1 F2 C in
	 F1 = {New Open.file init(name:"./components/"#Type#".fbp" flags:[read])}
	 F2 = {F1 read(list:$ size:all)}
	 C = {FBP.parse F2}
	 {SubComponent.new Name Type C}
      end
   end
   proc {Start Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp}
	  {Comp.comp start}
       end
      }
   end
   proc {Stop Graph}
      {Record.forAll Graph.nodes
       proc {$ Comp} State in
	  {Comp.comp getState(State)}
	  if {Label State} == subcomponent orelse {Record.width State.inPorts} == 0 then
	     {Comp.comp stop}
	  end
       end
      }
   end
end