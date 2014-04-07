functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:textCreate
		   outPorts(actions_out opt ui_out)
		   inPorts(ui_in: proc {$ Buf Out NVar State Options} Rec H Events in
				  Rec = {Buf.get}
				  {Out.ui_out {Record.adjoinAt {Rec Out.actions_out} handle H}}
				  {Wait H}
				 % {H bind(event:"<Enter>"
				 % 	 action: proc{$} {Out.actions_out 'Enter'} end
				 % 	)}
				 % {H bind(event:"<Leave>"
				 % 	 action: proc{$} {Out.actions_out 'Leave'} end
				 % 	)}
				 % {H bind(event:"<FocusIn>"
				 % 	 action: proc{$} {Out.actions_out 'FocusIn'} end
				 % 	)}
				  Events = ['Activate'#nil
					    'Deactivate'#nil
					    'FocusIn'#nil
					    'FocusOut'#nil
					   ]
				  for E#Args in Events do
				     {H bind(event:"<"#{Atom.toString E}#">"
					     args:Args
					     action: proc{$} {Out.actions_out E} end
					    )}
				  end
				  for E in ['KeyPress' 'KeyRelease'] do
				     {H bind(event:"<"#{Atom.toString E}#">"
					     args:[int(k) int(x) int(y)]
					     action: proc {$ K X Y} {Out.actions_out E(key:K x:X y:Y)} end
					    )}
				  end
				  for E in ['ButtonPress' 'ButtonRelease'] do
				     {H bind(event:"<"#{Atom.toString E}#">"
					     args:[int(b) int(x) int(y)]
					     action: proc {$ B X Y} {Out.actions_out E(button:B x:X y:Y)} end
					    )}
				  end
				  for E in ['Enter' 'Leave'] do
				     {H bind(event:"<"#{Atom.toString E}#">"
					     args:[string(d) int(f) string(m) int(x) int(y) string(s)]
					     action: proc{$ D F M X Y S} {Out.actions_out E(detail:D focus:F mode:M x:X y:Y state:S)} end
					    )}
				  end
				  {Out.opt opt(handle:H)}
			       end)
		   )
      }
   end
end
