functor
import
   Open
   Module
   FBP at './fbpParser.ozf'
   Component at './component.ozf'
   SubComponent at './subcomponent.ozf'
export
   Load
define
   ComponentCache = {NewDictionary}
   SubComponentCache = {NewDictionary}
   fun {Load Name Type}
      if {Dictionary.member ComponentCache Type} then
	 {Component.new Name Type ComponentCache.Type}
      elseif {Dictionary.member SubComponentCache Type} then
	 {SubComponent.new Name Type SubComponentCache.Type}
      else
	 try C in
	    [C] = {Module.link ["./components/"#Type#".ozf"]}
	    ComponentCache.Type := C.component
	    {Component.new Name Type C.component}
	 catch system(module(notFound load _)) then F1 F2 C in
	    try
	       F1 = {New Open.file init(name:"./components/"#Type#".fbp" flags:[read])}
	       F2 = {F1 read(list:$ size:all)}
	       C = {FBP.parse F2}
	       SubComponentCache.Type := C
	       {SubComponent.new Name Type C}
	    catch E then
	       raise component_not_loaded(name:Name type:Type error:E) end
	    end
	 end
      end
   end
end