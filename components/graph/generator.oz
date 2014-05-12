functor
import
   Comp at '../../lib/component.ozf'
   SubComp at '../../lib/subcomponent.ozf'
   Module
   System
export
   new: New
define
   fun {New Name}
      {Comp.new component(
		   name: Name type:'graph/generator'
		   inPorts(type)
		   outPorts(output)
		   procedure(proc{$ Ins Out Comp} C Type Name TheComp in
				   Name#Type = {Ins.type.get}
				   try
				      [C] = {Module.link [Type]}
				      {Wait C}
				      TheComp = {C.new Name}
				   catch _ then
				      try
					 TheComp = {SubComp.new Name Type Type}
				      catch _ then
					 {System.show typenotfound#Type}
					 TheComp = nil
				      end
				   end
				   if TheComp \= nil then {Out.output newComp(TheComp)} end
				end)
		   )
      }
   end
end
     