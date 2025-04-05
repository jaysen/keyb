#Requires AutoHotkey v2.0+
; --- Hybrid 60% Keyboard Navigation with Vim Features ---
; --- Combines custom navigation with basic Vim commands ---

; Include shared libraries
#Include %A_ScriptDir%\keyb_lib.ahk
#Include %A_ScriptDir%\vim_lib.ahk
#SingleInstance Force

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; --- Mode Variables ---
global HybridVimEnabled := false

; Win+J toggles navigation mode
#j::
{
    KeybLib.ToggleNavMode()
    if (KeybLib.NavModeEnabled) {
        HybridVimEnabled := false
        VimLib.SwitchToNormal()
    }
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

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    KeybLib.ToggleCapsLock()
}

; --- Navigation Mode Hotkeys ---
#HotIf (GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled) and !HybridVimEnabled
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