#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---
; --- CapsLock Modifier with Toggle Navigation Mode ---

; Include the shared library
#Include ..\shared\keyb_lib.ahk
#Include ..\shared\text_lib.ahk
#Include ..\shared\nav_lib.ahk
#Include ..\shared\text_lib.ahk
#SingleInstance Force

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; Win+J toggles navigation mode
#j::
{
    KeybLib.ToggleNavMode(true)
}

; Handle CapsLock tap (without modifiers)
*CapsLock::
{
    ; Wait for the key to be released
    KeyWait "CapsLock"
    
    ; Check if it was a double-tap
    if (KeybLib.DetectCapsLockDoubleTap()) {
        ; Double tap detected, toggle navigation mode on
        if (!KeybLib.NavModeEnabled) {
            KeybLib.ToggleNavMode(true)
        }
        KeybLib.ResetCapsLockTapCount()
    } else if (KeybLib.NavModeEnabled) {
        ; Single tap while in nav mode - exit nav mode
        KeybLib.ToggleNavMode()
    }
    ; Otherwise do nothing, allowing CapsLock to be used as a modifier when held
}

; Activate hotkeys when CapsLock is held OR NavMode is enabled
#HotIf KeybLib.NavModeEnabled
    ; Escape exits navigation mode
    Escape::
    {
        KeybLib.ToggleNavMode()
    }
#HotIf

; Activate hotkeys when CapsLock is held OR NavMode is enabled
#HotIf GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled
    ; Arrow keys (WASD)
    *w::NavLib.MoveUp()
    *a::NavLib.MoveLeft()
    *s::NavLib.MoveDown()
    *d::NavLib.MoveRight()

    ; Arrow keys (IJKL)
    *i::NavLib.MoveUp()
    *j::NavLib.MoveLeft()
    *k::NavLib.MoveDown()
    *l::NavLib.MoveRight()

    ; Home, End, PageUp, PageDown
    *h::NavLib.MoveToLineStart()
    `;::TextLib.SelectLine()
    *'::NavLib.MoveToLineEnd()     
    *p::Send "+{End}"              ; keyd: p = S-end
    */::NavLib.PageDown()

    ; Word navigation (with Shift modifier support)
    *,::NavLib.MoveWordBackward()
    *.::NavLib.MoveWordForward()

    ; Document/navigation letters updated to match keyd
    *o::Send "^{Right}"            ; keyd: o = C-right
    *u::Send "^{Left}"             ; keyd: u = C-left
    *y::Send "+{Home}"             ; keyd: y = S-home
    *n::Send "+^{Left}"            ; keyd: n = S-C-left
    *m::Send "+{Left}"             ; keyd: m = S-left

    ; Selection home/end (letters)
    *e::Send "+{Home}"             ; keyd: e = S-home
    *r::Send "+{Up}"               ; keyd final: r = S-up (last-wins)
    *z::Send "+{Home}"             ; keyd: z = S-home
    *x::Send "+{End}"              ; keyd: x = S-end

    ; Selection down/up (letters)
    *f::Send "+{Down}"             ; keyd: f = S-down
    *t::Send "+{PgUp}"             ; keyd: t = S-pageup
    *g::Send "+{PgDn}"             ; keyd: g = S-pagedown

    ; Text manipulation (Delete/Backspace) — letters per keyd
    *q::Send "{Delete}"            ; keyd: q = delete
    ; (Tab stays as-is below/outside this "letters only" change)

    ; keep existing:
    *Tab::TextLib.ExpandSelectionByCharBack()  

    ; keep existing:
    *x::TextLib.ExpandSelectionToLineEnd()     ; (overridden above to match keyd)
    *z::TextLib.ExpandSelectionToLineStart()   ; (overridden above to match keyd)

  
    $[::TextLib.ExpandSelectionByWordBack()
    $]::TextLib.ExpandSelectionByWordForward()

    ; keep existing
    *f::TextLib.SelectCurrentWord()     
    *g::TextLib.SelectLine()         
    $\::TextLib.SelectLine()

    ; --- Block all other letter keys ---
    ;$b::Return
    ;$c::Return
    ;$e::Return
    ;$f::Return
    ;$g::Return
    ; h is Home
    ; i is Up
    ; j is Left
    ; k is Down
    ; l is Right
    ;$;::Return
    ; m is Ctrl+Down
    ;$n::Return
    ; $o::Return     ; (removed to allow keyd o = C-right)
    ; p is PgUp
    ;$q::Return
    ;$r::Return
    ; s is Down
    ;$t::Return
    ; u is Ctrl+Up
    ;$v::Return
    ; w is Up
    ;$x::Return  
    ;$y::Return
    ;$z::Return
    
    ; --- Block remaining symbols ---
    ; ' is End
    ;$[::Return
    ;$]::Return
    ;$\::Return
    $`::Return
    ; , is Ctrl+Left
    ; . is Ctrl+Right
    ; / is PgDn
    ; ; is End

    ; --- Block other common keys ---
    ; $Space::Return
    ; $Tab::Return
    ; $Enter::Return
    ; $BackSpace::Return
    ; $Delete::Return
    ; $Escape::Return
    
    ; --- Block all other printable characters ---
    $!::Return
    $@::Return
    $#::Return
    $$::Return
    $%::Return
    $^::Return
    $&::Return
    $*::Return
    $(::Return
    $)::Return
    $_::Return
    $+::Return


    ; Function keys F1 - F12
    *1::NavLib.SendFunctionKey(1)
    *2::NavLib.SendFunctionKey(2)
    *3::NavLib.SendFunctionKey(3)
    *4::NavLib.SendFunctionKey(4)
    *5::NavLib.SendFunctionKey(5)
    *6::NavLib.SendFunctionKey(6)
    *7::NavLib.SendFunctionKey(7)
    *8::NavLib.SendFunctionKey(8)
    *9::NavLib.SendFunctionKey(9)
    *0::NavLib.SendFunctionKey(10)
    *-::NavLib.SendFunctionKey(11)
    *=::NavLib.SendFunctionKey(12)
#HotIf

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    KeybLib.ToggleCapsLock()
}

; map CapsLock+Backspace to Delete :
CapsLock & Backspace::
{
    Send("{Delete}")
}

; map CapsLock+Delete to Delete (outside of NavMode) :
; Quick delete to save on reaching for backspace.
CapsLock & q::
{
    Send("{Delete}")
}

; map CapsLock+Tab to Backspace (outside of NavMode) :
; Quick backspace to save on reaching for backspace.
CapsLock & Tab::
{
    Send("{BackSpace}")
}
