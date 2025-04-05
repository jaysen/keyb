#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---
; --- CapsLock Modifier with Toggle Navigation Mode ---

; Include the shared library
#Include %A_ScriptDir%\..\shared\keyb_lib.ahk
#Include %A_ScriptDir%\..\shared\text_lib.ahk
#Include %A_ScriptDir%\..\shared\nav_lib.ahk
#Include %A_ScriptDir%\..\shared\text_lib.ahk
#SingleInstance Force

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
    *'::NavLib.MoveToLineEnd()
    *p::NavLib.PageUp()
    */::NavLib.PageDown()

    ; Word navigation (with Shift modifier support)
    *,::NavLib.MoveWordBackward()
    *.::NavLib.MoveWordForward()

    ; Document navigation
    *u::NavLib.MoveToDocStart()
    *m::NavLib.MoveToDocEnd()

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

    ; Text manipulation (TextLib)
    *f::TextLib.DeleteWord()            ; delete word forward
    *g::TextLib.DeleteWord(false)       ; delete word backward
    *y::TextLib.SelectLine()            ; select current line
    *x::TextLib.SelectCurrentWord()     ; select current word
    *z::TextLib.UppercaseSelection()    ; uppercase selected text
    *c::TextLib.ChangeToLineEnd()       ; delete to line end

    ; Block remaining unused keys
    $b::Return
    $e::Return
    $n::Return
    $q::Return
    $r::Return
    $t::Return
    $v::Return
    $[::Return
    $]::Return
    $;::Return
    $\::Return
#HotIf
