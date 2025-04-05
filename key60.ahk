#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---
; --- CapsLock Modifier with Toggle Navigation Mode ---

; Include the shared library
#Include %A_ScriptDir%\keyb_lib.ahk

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; Win+J toggles navigation mode
#j::
{
    KeybLib.ToggleNavMode()
}

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    KeybLib.ToggleCapsLock()
}

; Activate hotkeys when CapsLock is held OR NavMode is enabled
#HotIf GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled
    ; Arrow keys (WASD)
    *w::KeybLib.sendNavKey("Up")
    *a::KeybLib.sendNavKey("Left")
    *s::KeybLib.sendNavKey("Down")
    *d::KeybLib.sendNavKey("Right")
    ; Arrow keys (IJKL)
    *i::KeybLib.sendNavKey("Up")
    *j::KeybLib.sendNavKey("Left")
    *k::KeybLib.sendNavKey("Down")
    *l::KeybLib.sendNavKey("Right")
    ; Home, End, PageUp, PageDown
    *h::KeybLib.sendNavKey("Home")
    *'::KeybLib.sendNavKey("End")
    *p::KeybLib.sendNavKey("PgUp")
    */::KeybLib.sendNavKey("PgDn")
    ; Ctrl+Arrow navigation (with Shift modifier support)
    *,::KeybLib.sendCtrlNav("Left")
    *.::KeybLib.sendCtrlNav("Right")
    *u::KeybLib.sendCtrlNav("Up")
    *m::KeybLib.sendCtrlNav("Down")
    ; Function keys F1 - F12
    *1::KeybLib.sendNavKey("F1")
    *2::KeybLib.sendNavKey("F2")
    *3::KeybLib.sendNavKey("F3")
    *4::KeybLib.sendNavKey("F4")
    *5::KeybLib.sendNavKey("F5")
    *6::KeybLib.sendNavKey("F6")
    *7::KeybLib.sendNavKey("F7")
    *8::KeybLib.sendNavKey("F8")
    *9::KeybLib.sendNavKey("F9")
    *0::KeybLib.sendNavKey("F10")
    *-::KeybLib.sendNavKey("F11")
    *=::KeybLib.sendNavKey("F12")
    ; Block all other letter keys
    $b::Return
    $c::Return
    $e::Return
    $f::Return
    $g::Return
    $n::Return
    $q::Return
    $r::Return
    $t::Return
    $v::Return
    $x::Return
    $y::Return
    $z::Return
    ; Block remaining symbols
    $[::Return
    $]::Return
    $;::Return
    $\::Return
#HotIf