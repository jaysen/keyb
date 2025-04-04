#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"
*CapsLock::Return

;+CapsLock toggles CapsLock state explicitly
#CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState  ; Toggle CapsLock state
}

; Activate hotkeys when CapsLock is held or toggled on
#HotIf GetKeyState("CapsLock", "P")
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

