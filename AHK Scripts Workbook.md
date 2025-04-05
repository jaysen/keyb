## AutoHotkey Scripts Reference

This document contains the full source code of AutoHotkey scripts used for keyboard navigation and Vim-style enhancements on a 60% keyboard.

---

### key60.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---
; --- CapsLock Modifier with Toggle Navigation Mode ---

; Global state variable
global NavModeEnabled := false

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; Win+J toggles navigation mode
#j::
{
    global NavModeEnabled  ; Reference the global variable inside the function
    NavModeEnabled := !NavModeEnabled  ; Toggle nav mode
    if (NavModeEnabled)
    {
        ToolTip "Navigation Mode: ON", 10, 10
        SetTimer () => ToolTip(), -1500  ; Hide tooltip after 1.5 seconds
    }
    else
    {
        ToolTip "Navigation Mode: OFF", 10, 10
        SetTimer () => ToolTip(), -1500
    }
}

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState  ; Toggle CapsLock state
}

; Activate hotkeys when CapsLock is held OR NavMode is enabled
#HotIf GetKeyState("CapsLock", "P") or NavModeEnabled
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
```

---

### key60vim.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- CapsLock Modifier for 60% Keyboard with Vim-Style Navigation ---
; --- CapsLock with Numbers for fn keys ---
; --- Win+J to toggle Navigation Mode, Win+V to toggle Vim Mode ---

; Global state variables
global NavModeEnabled := false
global VimModeEnabled := false

SetCapsLockState "AlwaysOff"

#j::{
    global NavModeEnabled, VimModeEnabled
    NavModeEnabled := !NavModeEnabled
    if (NavModeEnabled) {
        VimModeEnabled := false
        ToolTip "Navigation Mode: ON", 10, 10
        SetTimer () => ToolTip(), -1500
    } else {
        ToolTip "Navigation Mode: OFF", 10, 10
        SetTimer () => ToolTip(), -1500
    }
}

#v::{
    global VimModeEnabled, NavModeEnabled
    VimModeEnabled := !VimModeEnabled
    if (VimModeEnabled) {
        NavModeEnabled := false
        ToolTip "Vim Mode: ON", 10, 10
        SetTimer () => ToolTip(), -1500
    } else {
        ToolTip "Vim Mode: OFF", 10, 10
        SetTimer () => ToolTip(), -1500
    }
}

#CapsLock::{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState
}

#HotIf (GetKeyState("CapsLock", "P") or NavModeEnabled) and !VimModeEnabled
    *w::sendNavKey("Up")
    *a::sendNavKey("Left")
    *s::sendNavKey("Down")
    *d::sendNavKey("Right")
    *i::sendNavKey("Up")
    *j::sendNavKey("Left")
    *k::sendNavKey("Down")
    *l::sendNavKey("Right")
    *h::sendNavKey("Home")
    *'::sendNavKey("End")
    *p::sendNavKey("PgUp")
    */::sendNavKey("PgDn")
    *,::sendCtrlNav("Left")
    *.::sendCtrlNav("Right")
    *u::sendCtrlNav("Up")
    *m::sendCtrlNav("Down")
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
```

---

### vim.ahk

```autohotkey
; AHK v2 script for Vim emulation
#Requires AutoHotkey v2.0
#SingleInstance Force

; ===== Vim Emulation Script =====
; This script emulates basic Vim functionality in standard Windows applications

; ===== Global Variables =====
global VimMode := "Normal"  ; Tracks current mode: "Normal", "Insert", "Visual"
global StatusBarVisible := false
global OldClipboard := ""
global StatusGui := Gui()

; ===== Helper Functions =====
ShowMode() {
    global VimMode, StatusBarVisible, StatusGui
    if (StatusBarVisible) {
        StatusGui.Destroy()
    }
    modeColor := "00FF00"
    if (VimMode = "Normal")
        modeColor := "0000FF"
    else if (VimMode = "Visual")
        modeColor := "FF0000"
    StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    StatusGui.BackColor := modeColor
    StatusGui.SetFont("s10 c" . (VimMode = "Normal" ? "FFFFFF" : "000000"), "Arial")
    StatusGui.Add("Text", "w100 Center", VimMode . " MODE")
    StatusGui.Show("NoActivate y0")
    StatusBarVisible := true
    SetTimer HideStatusBar, 1500
    return
}

HideStatusBar() {
    global StatusBarVisible, StatusGui
    StatusGui.Destroy()
    StatusBarVisible := false
    SetTimer HideStatusBar, 0
    return
}

SaveClipboard() {
    global OldClipboard
    OldClipboard := ClipboardAll()
    A_Clipboard := ""
    return
}

RestoreClipboard() {
    global OldClipboard
    A_Clipboard := OldClipboard
    OldClipboard := ""
    return
}

Escape:: {
    global VimMode
    VimMode := "Normal"
    ShowMode()
}

#HotIf (VimMode = "Normal")
    i:: {
        global VimMode
        VimMode := "Insert"
        ShowMode()
    }
    v:: {
        global VimMode
        VimMode := "Visual"
        ShowMode()
    }
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
    g:: {
        if A_PriorHotkey = "g" && A_TimeSincePriorHotkey < 400
            Send("^{Home}")
    }
    +g:: Send("^{End}")
    x:: Send("{Delete}")
    s:: {
        Send("{Delete}")
        VimMode := "Insert"
        ShowMode()
    }
    d:: {
        if A_PriorHotkey = "d" && A_TimeSincePriorHotkey < 400 {
            SaveClipboard()
            Send("{Home}+{End}^x")
            RestoreClipboard()
        }
    }
    y:: {
        if A_PriorHotkey = "y" && A_TimeSincePriorHotkey < 400 {
            SaveClipboard()
            Send("{Home}+{End}^c{Right}")
            RestoreClipboard()
        }
    }
    p:: {
        SaveClipboard()
        Send("^v")
        RestoreClipboard()
    }
    +p:: {
        SaveClipboard()
        Send("{Left}^v")
        RestoreClipboard()
    }
    u:: Send("^z")
    ^r:: Send("^y")
    /:: Send("^f")
    +i:: {
        Send("{Home}")
        VimMode := "Insert"
        ShowMode()
    }
    +a:: {
        Send("{End}")
        VimMode := "Insert"
        ShowMode()
    }
    o:: {
        Send("{End}{Enter}")
        VimMode := "Insert"
        ShowMode()
    }
    +o:: {
        Send("{Home}{Enter}{Up}")
        VimMode := "Insert"
        ShowMode()
    }
    +c:: {
        Send("+{End}^x")
        VimMode := "Insert"
        ShowMode()
    }
    r:: {
        Input := InputHook("L1")
        Input.Start()
        Input.Wait()
        Send(Input.Input)
    }
#HotIf

#HotIf (VimMode = "Visual")
    h:: Send("+{Left}")
    j:: Send("+{Down}")
    k:: Send("+{Up}")
    l:: Send("+{Right}")
    w:: Send("+^{Right}")
    b:: Send("+^{Left}")
    0:: Send("+{Home}")
    $:: Send("+{End}")
    y:: {
        SaveClipboard()
        Send("^c")
        VimMode := "Normal"
        ShowMode()
        RestoreClipboard()
    }
    d:: {
        SaveClipboard()
        Send("^x")
        VimMode := "Normal"
        ShowMode()
        RestoreClipboard()
    }
    x:: {
        Send("{Delete}")
        VimMode := "Normal"
        ShowMode()
    }
#HotIf

VimMode := "Normal"
ShowMode()
```

---

_This document can be extended with launcher scripts, helper library files, and more._