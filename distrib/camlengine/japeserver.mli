    type box = Box.M.box
    and displayclass = Displayclass.M.displayclass
    and font = Displayfont.M.displayfont
    and pane = Displayfont.M.pane
    and panelkind = Panelkind.M.panelkind
    and panelbuttoninsert = Panelkind.M.panelbuttoninsert
    and pos = Box.M.pos
    and size = Box.M.size
    and textsize = Box.M.textsize
    
    val idlsignature : string
    val getSignature : unit -> string
    val sendVersion : string -> unit
    val sendOperators : string list -> unit
    val setFonts : string -> unit
    (* send font-encoding name *)
    val fontinfo : font -> int * int * int
    (* ascent, descent, leading *)
       
       (* By default all drawing takes place in the front window. 
        * When fonts change, background windows have to be refreshed.
        * The following allow the engine temporarily to redirect
        * drawing to a background window.  If canbackgroundfocus is false, 
        * it won't do such a thing.
        *)
    val canbackgroundfocus : bool
    val setbackgroundfocus : int -> unit
    val setforegroundfocus : unit -> unit
    val measurestring : font * string -> int * int * int
    val procrustes : int -> string -> font -> string -> string
    (* width   ...               string    what fits *)

(* drawmeasuredtext takes a selection class (0 is non-selectable),
                 an (offset*font*string) list and
                 a position
*)
    val drawmeasuredtext :
      displayclass -> (pos * font * string) list -> pos -> unit
    (* nowadays we can draw in the proof pane or the disproof pane *)
    val drawinpane : pane -> unit
    (* disproof has sequent and term-buttons and worlds; disproof sequent is drawn separately *)
    val setdisproofseqbox : box -> unit
    (* followed by some drawing *)
    val setdisprooftiles : string list -> unit
    val setdisproofworlds :
      (int * int) list ->
        ((int * int) * string list * (int * int) list) list -> unit
    (* the mad world of menus and panels *)
    val cancelmenusandpanels : unit -> unit
    val emptymenusandpanels : unit -> unit
    val newmenu : string -> unit
    val menuentry : string * string * string option * string -> unit
    (* menu, label, key equiv, cmd *)
    val menucheckbox : string * string * string -> unit
    (* menu, label, cmd *)
    val menuradiobutton : string * (string * string) list -> unit
    (* menu, (label, cmd) *)
    val menuseparator : string -> unit
    (* menu *)
    val enablemenuitem : string * string * bool -> unit
    (* applies to entries, checkboxes, radio buttons *)
    val tickmenuitem : string * string * bool -> unit
    (* only for checkboxes, radio buttons *)

    val mapmenus : bool -> unit
    (* false: menus under construction; true: menus constructed *)
     
    val newpanel : string * panelkind -> unit
    val panelentry : string * string * string -> unit
    val panelbutton : string * string * panelbuttoninsert list -> unit
    val panelcheckbox : string * string * string -> unit
    val panelradiobutton : string * (string * string) list -> unit
    val setpanelbutton : string * string * bool -> unit
    val selectpanelentry : string * string -> unit
    val markpanelentry : string -> string -> bool -> unit
    val listen : unit -> string
    val terminate : unit -> unit
    val closedown : unit -> unit
    val killserver : unit -> unit
    val drawLine : box -> unit
    (* top right to bottom left, staying within the box, 
                                    using linethickness from setproofparams
                                  *)
    val drawRect : box -> unit
    (* just inside the box, using linethickness from setproofparams *)

    val running : bool ref
    val servername : string ref
    val startserver : string -> string list -> unit
    val stopserver : unit -> unit
    val openproof : string * int -> unit
    val closeproof : int -> unit
    val showfile : string -> unit
    val echo : string -> string
    val setProvisos : font * string list -> unit
    (* font * provisos *)
    val setGivens : (int * string) list -> unit
    (* numbered givens *)
       
    val quit : unit -> unit
    val dontquit : unit -> unit
    val getProofPane : unit -> box
    val getDisproofPane : unit -> box
    val clearProofPane : unit -> unit
    val clearDisproofPane : unit -> unit
    (* To make findSelection (interaction.sml) work properly, and to get consistent results from tactics that
     * interpret the answers, getAllSelections should return its answers in time-click order.
     *)
    val getAllSelections :
      unit ->
        (pos * displayclass) list * (pos * string list) list * string list
    (* selections               prooof text selections     givens text selections *)

    val highlight : pos -> displayclass option -> unit
    (* NOW TAKES TEXTPOS, NOT BOXPOS!!! *)
    val emphasise : pos -> bool -> unit
    (* also textpos; used in disproof *)

    val greyen : pos -> unit
    val blacken : pos -> unit
    val toplevelfiletype : int
    (* .jt *)
    val theoryfiletype : int
    (* .j  *)
    val prooffiletype : int
    (* .jp *)
       
    val dbugfiletype : int
    (* whatever you like *)
       
       (* In the following calls, 
        *   string is a message to put in the dialogue box,
        *   int is a filetype
        * Either argument may be safely ignored.
        *)
    val writeFileName : string -> int -> string option
    val readFileName : string -> int -> string option
    val resetcache : unit -> unit
    (* forget all cached information *)
     
     (* how to draw things *)
    val setinvischars :
      string * string -> string * string -> string * string ->
        string * string -> unit
    (*   onbra  ket         offbra ket         outbra ket         lockbra ket *)
    val setproofparams : string -> int -> unit
    (*    tree/box  linethickness *)

(* interface-specific help information *)
    val howtoTextSelect : unit -> string
    val howtoFormulaSelect : unit -> string
    val howtoDrag : unit -> string
    (* nascent variable mirroring *)
    val settextselectionmode : string -> unit
    
    val setComment : string -> unit
    (* this demoted to a thing which sets a comment line *)
       
    val ask_unpatched : int -> string -> string list -> int -> int
    (* severity 0/1/2    message   buttons     default   which one was pressed, indexed from 0*)

    val askCancel_unpatched :
      int -> string -> string list -> int -> int option
    (* severity 0/1/2    message   buttons      default  Some button (counting from 0) or None for Cancel 
     *             set default = length buttons to choose Cancel
     *)


    val askDangerously_unpatched : string -> string -> string -> int option
    (* message   Do        Don't     Some button (counting from 0) or None for Cancel
     * special version of ask_cancel, with Do as default, and
     * the buttons in "Do/Don't" positions -- like this
     * 
     * ICON
     * ICON                    message
     * ICON 
     * 
     * Don't                Cancel  Do
     *)

    val askChoice : string * string list list -> int option

