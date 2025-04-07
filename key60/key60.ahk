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
    `;::NavLib.MoveToLineEnd()
    *p::NavLib.PageUp()
    */::NavLib.PageDown()

    ; Word navigation (with Shift modifier support)
    *,::NavLib.MoveWordBackward()
    *.::NavLib.MoveWordForward()

    ; Document navigation
    *u::NavLib.MoveUpLines(2)
    *m::NavLib.MoveDownLines(2)
    *y::NavLib.MoveUpLines(5)
    *n::NavLib.MoveDownLines(5)   
    *t::NavLib.MoveUpLines(10)
    *b::NavLib.MoveDownLines(10)   

    ; Text manipulation (Delete, Backspace, etc.)
    ; *z::Send("{BackSpace}")
    ; *x::Send("{Delete}")
    ; Text manipulation (TextLib)
    ; *c::TextLib.DeleteWord(false)       ; delete word backward
    ; *v::TextLib.DeleteWord(true)        ; delete word forward
    ; *r::TextLib.ChangeToLineEnd()       ; delete to line end
    ; *t::TextLib.UppercaseSelection()    ; uppercase selected text

    *f::TextLib.SelectCurrentWord()     ; select current word
    *g::TextLib.SelectLine()            ; select current line
    *q::TextLib.SelectLine()            ; select current line

    ; *z::TextLib.ExpandSelectionByWordBack()
    ; *x::TextLib.ExpandSelectionByCharBack()
    ; *c::TextLib.ExpandSelectionByWordForward()  
    ; *v::TextLib.ExpandSelectionByCharForward()

    *e::TextLib.ExpandSelectionByWordBack()
    *r::TextLib.ExpandSelectionByWordForward()  
    *c::TextLib.ExpandSelectionByCharBack()
    *v::TextLib.ExpandSelectionByCharForward()

    *x::TextLib.ExpandSelectionToLineEnd()     
    *z::TextLib.ExpandSelectionToLineStart()     
    *'::TextLib.ExpandSelectionToLineEnd()     
  
    $[::TextLib.ExpandSelectionByWordBack()
    $]::TextLib.ExpandSelectionByWordForward()

    ; Block remaining unused keys
    ;$q::Return
    ;$e::Return
    ;$r::Return
    ;$t::Return
    $o::Return
    ;$v::Return
    ;$b::Return
    ;$n::Return
    ;$[::Return
    ;$]::Return
    $\::TextLib.SelectLine()


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

CapsLock & q::
{
    Send("{Delete}")
}
