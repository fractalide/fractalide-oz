functor
import
   Comp at '../../lib/component.ozf'
   Qtk at 'x-oz://system/wp/QTk.ozf'
export
   new: CompNewArgs
define
   fun {CompNewArgs Name}
      {Comp.new comp(
		   name:Name type:window
		   outPorts(actions_out opt)
		   inPorts(
		      ui_in: proc{$ Buf Out NVar State Options} IP H Events in
				IP = {Buf.get}
				H = {Qtk.build td(IP)}
				{H show}
				{Out.opt opt(handle:H)}
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
			     end
		      )
		   )
      }
   end
end