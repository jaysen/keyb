#Requires AutoHotkey v2.0+
; --- CapsLock Modifier for 60% Keyboard with Vim-Style Navigation ---
; --- CapsLock with Numbers for fn keys ---
; --- Win+J to toggle Navigation Mode, Win+V to toggle Vim Mode ---

; Include the shared library
#Include %A_ScriptDir%\keyb_lib.ahk

SetCapsLockState "AlwaysOff"

#j::
{
    KeybLib.ToggleNavMode()
}

#v::
{
    KeybLib.ToggleVimMode()
}

#CapsLock::
{
    KeybLib.ToggleCapsLock()
}

#HotIf (GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled) and !KeybLib.VimModeEnabled
    *w::KeybLib.sendNavKey("Up")
    *a::KeybLib.sendNavKey("Left")
    *s::KeybLib.sendNavKey("Down")
    *d::KeybLib.sendNavKey("Right")
    *i::KeybLib.sendNavKey("Up")
    *j::KeybLib.sendNavKey("Left")
    *k::KeybLib.sendNavKey("Down")
    *l::KeybLib.sendNavKey("Right")
    *h::KeybLib.sendNavKey("Home")
    *'::KeybLib.sendNavKey("End")
    *p::KeybLib.sendNavKey("PgUp")
    */::KeybLib.sendNavKey("PgDn")
    *,::KeybLib.sendCtrlNav("Left")
    *.::KeybLib.sendCtrlNav("Right")
    *u::KeybLib.sendCtrlNav("Up")
    *m::KeybLib.sendCtrlNav("Down")
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
    $[::Return
    $]::Return
    $;::Return
    $\::Return
#HotIf