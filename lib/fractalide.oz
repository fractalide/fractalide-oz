/*
<one line to give the program's name and a brief idea of what it does.>
Copyright (C) 2014 Noware Ltd.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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