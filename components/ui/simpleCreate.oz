functor
import
   Comp at '../../lib/component.ozf'
export
   new: New
define
   fun {New Name} 
      {Comp.new component(
		   name: Name type:textCreate
		   state(handle:nil)
		   outPorts(actions_out opt ui_out)
		   inPorts(ui_in(proc{$ In Out Comp} NewUI HandlePH HandleNewUI Events GeneralOptions in
				     NewUI = {{In.get} Out.actions_out}
				     GeneralOptions = {Record.filterInd NewUI
						       fun {$ I _}
							  {List.member I
							   [glue width height]}
						       end}
				     % Initialize the placeholder
				     if Comp.state.handle == nil then
					{Out.ui_out {Record.adjoin GeneralOptions placeholder(handle: HandlePH)}}
					{Wait HandlePH}
					Comp.state.handle := HandlePH
				     end

				     {Comp.state.handle set({Record.adjoinAt NewUI handle HandleNewUI})}

				  Events = ['Activate'#nil
					    'Deactivate'#nil
					    'FocusIn'#nil
					    'FocusOut'#nil
					   ]
				  for E#Args in Events do
				     {HandleNewUI bind(event:"<"#{Atom.toString E}#">"
					     args:Args
					     action: proc{$} {Out.actions_out E} end
					    )}
				  end
				  for E in ['KeyPress' 'KeyRelease'] do
				     {HandleNewUI bind(event:"<"#{Atom.toString E}#">"
					     args:[int(k) int(x) int(y) string(s) string('A') string('T') string('W') string('K') int('X') int('Y')]
					     action: proc {$ K X Y S A T W TK XR YR} {Out.actions_out E(key:K x:X y:Y state:S ascii:A type:T path:W textual_string:TK x_root:XR y_root:YR)} end
					    )}
				  end
				  for E in ['ButtonPress' 'ButtonRelease'] do
				     {HandleNewUI bind(event:"<"#{Atom.toString E}#">"
					     args:[int(b) int(x) int(y)]
					     action: proc {$ B X Y} {Out.actions_out E(button:B x:X y:Y)} end
					    )}
				  end
				  {HandleNewUI bind(event:"<Motion>"
						    args:[int(x) int(y) string(s)]
						    action: proc{$ X Y S} {Out.actions_out 'Motion'(x:X y:Y state:S)} end
						   )}
				  for E in ['Enter' 'Leave'] do
				     {HandleNewUI bind(event:"<"#{Atom.toString E}#">"
					     args:[string(d) int(f) string(m) int(x) int(y) string(s)]
					     action: proc{$ D F M X Y S} {Out.actions_out E(detail:D focus:F mode:M x:X y:Y state:S)} end
					    )}
				  end
				  {Out.opt opt(handle:HandleNewUI handlePH:HandlePH)}
			       end)
			  )
		   )
      }
   end
end
