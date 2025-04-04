#Requires AutoHotkey v2.0+
; --- CapsLock Modifier for 60% Keyboard with Vim-Style Navigation ---
; --- CapsLock with Numbers for fn keys ---
; --- Win+J to toggle Navigation Mode, Win+V to toggle Vim Mode ---

; Global state variables
global NavModeEnabled := false
global VimModeEnabled := false

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; Win+J toggles navigation mode
#j::
{
    global NavModeEnabled, VimModeEnabled
    NavModeEnabled := !NavModeEnabled  ; Toggle nav mode
    
    if (NavModeEnabled)
    {
        VimModeEnabled := false  ; Exit Vim mode when toggling nav mode
        ToolTip "Navigation Mode: ON", 10, 10
        SetTimer () => ToolTip(), -1500  ; Hide tooltip after 1.5 seconds
    }
    else
    {
        ToolTip "Navigation Mode: OFF", 10, 10
        SetTimer () => ToolTip(), -1500
    }
}

; Win+V toggles Vim mode
#v::
{
    global VimModeEnabled, NavModeEnabled
    VimModeEnabled := !VimModeEnabled  ; Toggle vim mode
    
    if (VimModeEnabled)
    {
        NavModeEnabled := false  ; Exit Nav mode when toggling vim mode
        ToolTip "Vim Mode: ON", 10, 10
        SetTimer () => ToolTip(), -1500
    }
    else
    {
        ToolTip "Vim Mode: OFF", 10, 10
        SetTimer () => ToolTip(), -1500
    }
}

; Win+CapsLock toggles actual CapsLock state
#CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState  ; Toggle CapsLock state
}

; Normal Navigation Mode
#HotIf (GetKeyState("CapsLock", "P") or NavModeEnabled) and !VimModeEnabled
    ; Arrow keys (WASD)
    *w::sendNavKey("Up")
    *a::sendNavKey("Left")
    *s::sendNavKey("Down")
    *d::sendNavKey("Right")
    ; Arrow keys (IJKL)
    *i::sendNavKey("Up")
    *j::sendNavKey("Left")
    *k::sendNavKey("Down")
    *l::sendNavKey("Right")
    ; Home, End, PageUp, PageDown
    *h::sendNavKey("Home")
    *'::sendNavKey("End")
    *p::sendNavKey("PgUp")
    */::sendNavKey("PgDn")
    ; Ctrl+Arrow navigation (with Shift modifier support)
    *,::sendCtrlNav("Left")
    *.::sendCtrlNav("Right")
    *u::sendCtrlNav("Up")
    *m::sendCtrlNav("Down")
    ; Function keys F1 - F12
    *1::sendNavKey("F1")
    *2::sendNavKey("F2")
    *3::sendNavKey("F3")
    *4::sendNavKey("F4")
    *5::sendNavKey("F5")
    *6::sendNavKey("F6")
    *7::sendNavKey("F7")
    *8::sendNavKey("F8")
    *9::sendNavKey("F9")
    *0::sendNavKey("F10")
    *-::sendNavKey("F11")
    *=::sendNavKey("F12")
   
    ; --- Block all other letter keys ---
    $b::Return
    $c::Return
    $e::Return
    $f::Return
    $g::Return
    ; h is Home
    ; i is Up
    ; j is Left
    ; k is Down
    ; l is Right
    $;::Return
    ; m is Ctrl+Down
    $n::Return
    $o::Return
    ; p is PgUp
    $q::Return
    $r::Return
    ; s is Down
    $t::Return
    ; u is Ctrl+Up
    $v::Return
    ; w is Up
    $x::Return
    $y::Return
    $z::Return
    ; --- Block remaining symbols ---
    ; ' is End
    $[::Return
    $]::Return
    $\::Return
    $`::Return
    ; , is Ctrl+Left
    ; . is Ctrl+Right
    ; / is PgDn
    ; --- Block other common keys ---
    $Space::Return
    $Tab::Return
    $Enter::Return
    $BackSpace::Return
    $Delete::Return
    $Escape::Return
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
#HotIf

; Vim Mode Navigation
#HotIf (GetKeyState("CapsLock", "P") or VimModeEnabled) and !NavModeEnabled
    ; Basic Vim movement keys
    $h::sendNavKey("Left")      ; Left
    $j::sendNavKey("Down")      ; Down
    $k::sendNavKey("Up")        ; Up
    $l::sendNavKey("Right")     ; Right
    
    ; Extended Vim navigation
    $0::sendNavKey("Home")      ; Beginning of line
    $$::sendNavKey("End")       ; End of line
    $b::sendCtrlNav("Left")     ; Back one word
    $w::sendCtrlNav("Right")    ; Forward one word
    ${::sendCtrlNav("Up")       ; Paragraph up
    $}::sendCtrlNav("Down")     ; Paragraph down
    
    ; Special g commands
    $g::
    {
        ; This implements 'gg' to go to document start
        if (A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 400)
            Send "^{Home}"
    }
    
    ; G to go to end of document
    $+g::Send "^{End}"
    
    ; Page navigation
    $^u::sendNavKey("PgUp")     ; Half page up
    $^d::sendNavKey("PgDn")     ; Half page down
    
    ; Function keys F1 - F12
    $1::sendNavKey("F1")
    $2::sendNavKey("F2")
    $3::sendNavKey("F3")
    $4::sendNavKey("F4")
    $5::sendNavKey("F5")
    $6::sendNavKey("F6")
    $7::sendNavKey("F7")
    $8::sendNavKey("F8")
    $9::sendNavKey("F9")
    ; 0 is used for beginning of line
    $-::sendNavKey("F11")
    $=::sendNavKey("F12")
    
    ; --- Block remaining keys that don't have Vim functions ---
    $a::Return
    $c::Return
    $d::Return
    $e::Return
    $f::Return
    ; g has special function
    ; h,j,k,l are for navigation
    $i::Return
    $m::Return
    $n::Return
    $o::Return
    $p::Return
    $q::Return
    $r::Return
    $s::Return
    $t::Return
    $u::Return
    $v::Return
    ; w is word forward
    $x::Return
    $y::Return
    $z::Return
    
    ; --- Block remaining symbols without Vim functions ---
    $'::Return
    $[::Return
    $]::Return
    $\::Return
    $`::Return
    $,::Return
    $.::Return
    $/::Return
    $;::Return
    ; --- Block other common keys ---
    $Space::Return
    $Tab::Return
    $Enter::Return
    $BackSpace::Return
    $Delete::Return
    $Escape::Return
    ; --- Block remaining printable characters ---
    $!::Return
    $@::Return
    ; # is Windows key
    ; $ is End of line in Vim
    $%::Return
    ; ^ is used in Ctrl combinations
    $&::Return
    $*::Return
    ; ( and ) not blocked for potential use
    $_::Return
    ; + is used with g for G
#HotIf

; Function to handle modifiers and send keys
sendNavKey(key) {
    mods := ""
    if GetKeyState("Ctrl", "P") {
        mods .= "^"
    }
    if GetKeyState("Shift", "P") {
        mods .= "+"
    }
    Send mods "{" key "}"
}

; Function specifically for Ctrl navigation keys with optional Shift
sendCtrlNav(key) {
    mods := "^"
    if GetKeyState("Shift", "P") {
        mods .= "+"
    }
    Send mods "{" key "}"
}