functor
export
   ManageIP
   SendOut
   FeedBuffer
   BindEvents
   BindBasicEvents
   RecordIncInd
define
   proc {SendOut OutPorts Event}
      if {List.member {Label Event} {Arity OutPorts.action}} then
	 {OutPorts.action.{Label Event} Event}
      else
	 {OutPorts.out Event}
      end
   end
   proc {ManageIP IP Out Comp}
      % Manage the IP that arrives before the creation
      if {Not {IsDet Comp.state.handle}} then
	 Comp.state.buffer := IP | Comp.state.buffer
      else
	 {Handle IP Out Comp}
      end
   end
   proc {FeedBuffer Out Comp}
      for IP in {Reverse Comp.state.buffer} do
	 {Handle IP Out Comp}
      end
      Comp.state.buffer := nil
   end
   proc {Handle IP Out Comp}

	 % Manage the IP : general actions and try the actions on the handle
      case {Label IP}
      of display then {SendOut Out set(Comp.state.handle)}
      [] getHandle then R in
	 R = {Record.make IP.output [1]}
	 R.1 = Comp.state.handle
	 {SendOut Out R} 
      [] getEntryPoint then R in
	 R = {Record.make IP.output [1]}
	 R.1 = Comp.entryPoint
	 {SendOut Out R}
      else
	 if {HasFeature IP output} then Res ResArg Get L in
	    Get = {Record.subtractList IP [output arg]}
	    L = if {Record.width Get} == 0 then [1] else {Record.toList Get} end
	    Res = {Record.make IP.output
		   L
		  }
	    ResArg = if {HasFeature IP arg} then
			{Record.adjoin IP.arg Res}
		     else
			Res
		     end
	    try
	       {Comp.state.handle {Record.adjoin ResArg {Label IP}}}
	       {SendOut Out ResArg}
	    catch _ then
	       {SendOut Out IP}
	    end
	 else
	    try {Comp.state.handle IP}
	    catch _ then
	       {SendOut Out IP}
	    end
	 end
      end
   end
   proc {BindBasicEvents Handle Out}
      for E in ['ButtonPress' 'ButtonRelease'] do
	 {Handle bind(event:"<"#{Atom.toString E}#">"
		      args:[int(b) int(x) int(y)]
		      action: proc {$ B X Y} {SendOut Out E(button:B x:X y:Y)} end
		     )}
      end
      {Handle bind(event:"<Motion>"
		   args:[int(x) int(y) string(s)]
		   action: proc{$ X Y S} {SendOut Out 'Motion'(x:X y:Y state:S)} end
		  )}
      for E in ['Enter' 'Leave'] do
	 {Handle bind(event:"<"#{Atom.toString E}#">"
		      args:[string(d) int(f) string(m) int(x) int(y) string(s)]
		      action: proc{$ D F M X Y S} {SendOut Out E(detail:D focus:F mode:M x:X y:Y state:S)} end
		     )}
      end
      for E in ['KeyPress' 'KeyRelease'] do
	 {Handle bind(event:"<"#{Atom.toString E}#">"
		      args:[int(k) int(x) int(y) string(s) string('A') string('T') string('W') string('K') int('X') int('Y')]
		      action: proc {$ K X Y S A T W TK XR YR} {SendOut Out E(key:K x:X y:Y state:S ascii:A type:T path:W textual_string:TK x_root:XR y_root:YR)} end
		     )}
      end
   end
   proc {BindEvents Handle Out} Events in
      Events = ['Activate'
		'Deactivate'
		'FocusIn'
		'FocusOut'
	       ]
      for E in Events do
	 {Handle bind(event:"<"#{Atom.toString E}#">"
		      action: proc{$} {SendOut Out E} end
		     )}
      end
      {BindBasicEvents Handle Out}
   end
   fun {RecordIncInd Rec} NRec in
      NRec = {Record.make create
	      {List.map {Record.toListInd Rec}
	       fun {$ Ind#_} if {Int.is Ind} then Ind+1 else Ind end end}
	     }
      for I in {Arity NRec} do
	 if {Int.is I} then
	    NRec.I = Rec.(I-1)
	 else
	    NRec.I = Rec.I
	 end
      end
      NRec
   end
end