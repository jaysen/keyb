#Requires AutoHotkey v2.0+
; --- Hybrid 60% Keyboard Navigation with Vim Features ---
; --- Combines custom navigation with basic Vim commands ---

; Include shared libraries
#Include %A_ScriptDir%\..\shared\keyb_lib.ahk
#Include %A_ScriptDir%\..\shared\vim_lib.ahk
#Include %A_ScriptDir%\..\shared\nav_lib.ahk
#Include %A_ScriptDir%\..\shared\text_lib.ahk
#SingleInstance Force

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; --- Mode Variables ---
global HybridVimEnabled := false

; Win+J toggles navigation mode
#j::
{
    KeybLib.ToggleNavMode(true)
    if (KeybLib.NavModeEnabled) {
        HybridVimEnabled := false
        VimLib.SwitchToNormal()
    }
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
            KeybLib.ToggleNavMode()
        }
        KeybLib.ResetCapsLockTapCount()
    } else if (KeybLib.NavModeEnabled) {
        ; Single tap while in nav mode - exit nav mode
        KeybLib.ToggleNavMode()
    }
    ; Otherwise do nothing, allowing CapsLock to be used as a modifier when held
}

; Win+V toggles hybrid Vim mode
#v::
{
    global HybridVimEnabled
    HybridVimEnabled := !HybridVimEnabled
    if (HybridVimEnabled) {
        KeybLib.NavModeEnabled := false
        VimLib.SwitchToNormal()
        KeybLib.ShowTooltip("Hybrid Vim Mode: ON")
    } else {
        KeybLib.ShowTooltip("Hybrid Vim Mode: OFF")
    }
}

#HotIf KeybLib.NavModeEnabled and !HybridVimEnabled
    ; Escape exits navigation mode
    Escape::
    {
        KeybLib.ToggleNavMode()
    }
#HotIf

; --- Navigation Mode Hotkeys ---
#HotIf (GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled) and !HybridVimEnabled
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

; --- Hybrid Vim Mode Hotkeys ---
; These combine your navigation system with basic Vim commands

; Escape returns to Normal mode
#HotIf HybridVimEnabled
    Escape:: {
        VimLib.SwitchToNormal()
        
        ; Double-Escape exits Hybrid Vim mode
        if (A_PriorHotkey = "Escape" && A_TimeSincePriorHotkey < 400) {
            global HybridVimEnabled := false
            KeybLib.ShowTooltip("Hybrid Vim Mode: OFF")
        }
    }
#HotIf

; Normal mode commands
#HotIf HybridVimEnabled and (VimLib.VimMode = "Normal")
    ; Mode switches
    i:: VimLib.SwitchToInsert()
    v:: VimLib.SwitchToVisual()
    
    ; Navigation (using both Vim-style and arrow key style)
    h:: Send("{Left}")
    j:: Send("{Down}")
    k:: Send("{Up}")
    l:: Send("{Right}")
    w:: Send("^{Right}")
    b:: Send("^{Left}")
    0:: Send("{Home}")
    $:: Send("{End}")
    ^u:: Send("{PgUp}")
    ^d:: Send("{PgDn}")
    
    ; Special navigation
    g:: {
        if A_PriorHotkey = "g" && A_TimeSincePriorHotkey < 400
            Send("^{Home}")
    }
    +g:: Send("^{End}")
    
    ; Text manipulation
    x:: Send("{Delete}")
    d:: {
        if A_PriorHotkey = "d" && A_TimeSincePriorHotkey < 400
            VimLib.DeleteLine()
    }
    y:: {
        if A_PriorHotkey = "y" && A_TimeSincePriorHotkey < 400
            VimLib.YankLine()
    }
    p:: VimLib.Paste()
    +p:: VimLib.PasteBefore()
    
    ; Editing commands
    s:: {
        Send("{Delete}")
        VimLib.SwitchToInsert()
    }
    +i:: {
        Send("{Home}")
        VimLib.SwitchToInsert()
    }
    +a:: {
        Send("{End}")
        VimLib.SwitchToInsert()
    }
    o:: {
        Send("{End}{Enter}")
        VimLib.SwitchToInsert()
    }
    +o:: {
        Send("{Home}{Enter}{Up}")
        VimLib.SwitchToInsert()
    }
    
    ; Undo/Redo
    u:: Send("^z")
    ^r:: Send("^y")
    
    ; Search
    /:: Send("^f")
#HotIf

; Visual mode commands
#HotIf HybridVimEnabled and (VimLib.VimMode = "Visual")
    ; Navigation with selection
    h:: Send("+{Left}")
    j:: Send("+{Down}")
    k:: Send("+{Up}")
    l:: Send("+{Right}")
    w:: Send("+^{Right}")
    b:: Send("+^{Left}")
    0:: Send("+{Home}")
    $:: Send("+{End}")
    
    ; Actions on selection
    y:: {
        VimLib.SaveClipboard()
        Send("^c")
        VimLib.SwitchToNormal()
        VimLib.RestoreClipboard()
    }
    d:: {
        VimLib.SaveClipboard()
        Send("^x")
        VimLib.SwitchToNormal()
        VimLib.RestoreClipboard()
    }
    x:: {
        Send("{Delete}")
        VimLib.SwitchToNormal()
    }
#HotIf


; map CapsLock+Backspace to Delete :
CapsLock & Backspace::
{
    Send("{Delete}")
}

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    KeybLib.ToggleCapsLock()
}