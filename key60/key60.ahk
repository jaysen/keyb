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

; Escape exits navigation mode
; Note: This is only active when NavMode is enabled
#HotIf KeybLib.NavModeEnabled
    ; Escape exits navigation mode
    Escape::
    {
        KeybLib.ToggleNavMode()
    }
#HotIf

; Escape exits selection mode
; Note: This is only active when SelectionMode is enabled
#HotIf KeybLib.SelectionModeEnabled
    ; Escape exits selection mode
    Escape::
    {
        KeybLib.ToggleSelectionMode()
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
    *u::NavLib.sendCtrlNav("Up")
    *m::NavLib.sendCtrlNav("Down")

    ; Text manipulation (Delete, Backspace, etc.)
    ; *z::Send("{BackSpace}")
    ; *x::Send("{Delete}")
    ; Text manipulation (TextLib)
    ; *c::TextLib.DeleteWord(false)       ; delete word backward
    ; *v::TextLib.DeleteWord(true)        ; delete word forward
    ; *r::TextLib.ChangeToLineEnd()       ; delete to line end
    ; *t::TextLib.UppercaseSelection()    ; uppercase selected text

    *y::TextLib.SelectLine()            ; select current line
    *f::TextLib.SelectCurrentWord()     ; select current word
    *'::TextLib.SelectCurrentWord()     ; select current word

    ; *z::TextLib.ExpandSelectionByWordBack()
    ; *x::TextLib.ExpandSelectionByCharBack()
    ; *c::TextLib.ExpandSelectionByWordForward()  
    ; *v::TextLib.ExpandSelectionByCharForward()

    *e::TextLib.ExpandSelectionByWordBack()
    *r::TextLib.ExpandSelectionByWordForward()  
    *c::TextLib.ExpandSelectionByCharBack()
    *v::TextLib.ExpandSelectionByCharForward()

    ; Block remaining unused keys         
    ;$q::Return
    ;$e::Return
    ;$r::Return
    ;$t::Return
    ;$v::Return
    ;$b::Return
    $n::Return
    $[::Return
    $]::Return
    $\::Return

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



; Double-tap Left Shift to toggle selection mode
; Note: ~LShift means the key's native function still works
~LShift::
{
    ; Check if this is a double tap (400ms window)
    if (A_PriorHotkey = "~LShift" && A_TimeSincePriorHotkey < 400) {
        KeybLib.ToggleSelectionMode()
    }
}

; Selection mode hotkeys
#HotIf KeybLib.SelectionModeEnabled
    ; Arrow-based selection with IJKL
    i::TextLib.ExpandSelectionUp()
    j::TextLib.ExpandSelectionByCharBack()
    k::TextLib.ExpandSelectionDown()
    l::TextLib.ExpandSelectionByCharForward()
    
    ; Word-based selection with comma/period
    ,::TextLib.ExpandSelectionByWordBack()
    .::TextLib.ExpandSelectionByWordForward()
    
    ; Line-boundary selection with h/semicolon
    h::TextLib.ExpandSelectionToLineStart()
    `;::TextLib.ExpandSelectionToLineEnd()
    
    ; Additional useful selection operations
    u::TextLib.ExpandSelectionUp(5)     ; Select 5 lines up
    m::TextLib.ExpandSelectionDown(5)   ; Select 5 lines down
    y::TextLib.SelectLine()             ; Select entire line
    w::TextLib.SelectCurrentWord()      ; Select current word
    
    ; Clipboard operations that maintain selection mode
    c::
    {
        KeybLib.SaveClipboard()
        Send "^c"
        KeybLib.RestoreClipboard()
        KeybLib.ShowTooltip("Selection copied")
    }
    
    x::
    {
        KeybLib.SaveClipboard()
        Send "^x"
        KeybLib.RestoreClipboard()
        KeybLib.ToggleSelectionMode()   ; Exit selection mode after cutting
    }
    
    ; Text manipulation that maintains selection
    +z::TextLib.UppercaseSelection()    ; Uppercase selected text
#HotIf