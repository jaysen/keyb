# 60% Keyboard AutoHotkey Scripts Workbook

This workbook contains a collection of AutoHotkey scripts for enhancing the functionality of 60% keyboards with custom navigation and Vim-like features.

## Library Files

### nav_lib.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- Navigation Library ---
; Shared navigation functions for keyboard enhancement scripts

class NavLib {
    ; --- Core Navigation Helper ---
    static sendKey(key, modifiers := "") {
        cmd := ""
        if InStr(modifiers, "shift") or GetKeyState("Shift", "P")
            cmd .= "+"
        if InStr(modifiers, "ctrl") or GetKeyState("Ctrl", "P")
            cmd .= "^"
        if InStr(modifiers, "alt") or GetKeyState("Alt", "P")
            cmd .= "!"
        
        Send cmd "{" key "}"
    }
    
    ; --- Basic Navigation ---
    static MoveUp() {
        this.sendKey("Up")
    }
    
    static MoveDown() {
        this.sendKey("Down")
    }
    
    static MoveLeft() {
        this.sendKey("Left")
    }
    
    static MoveRight() {
        this.sendKey("Right")
    }
    
    ; --- Line Navigation ---
    static MoveToLineStart() {
        this.sendKey("Home")
    }
    
    static MoveToLineEnd() {
        this.sendKey("End")
    }
    
    ; --- Document Navigation ---
    static PageUp() {
        this.sendKey("PgUp")
    }
    
    static PageDown() {
        this.sendKey("PgDn")
    }
    
    ; --- Word Navigation ---
    static MoveWordForward() {
        if GetKeyState("Shift", "P")
            Send "+^{Right}"
        else
            Send "^{Right}"
    }
    
    static MoveWordBackward() {
        if GetKeyState("Shift", "P")
            Send "+^{Left}"
        else
            Send "^{Left}"
    }
    
    ; --- Advanced Navigation ---
    static MoveToDocStart() {
        if GetKeyState("Shift", "P")
            Send "+^{Home}"
        else
            Send "^{Home}"
    }
    
    static MoveToDocEnd() {
        if GetKeyState("Shift", "P")
            Send "+^{End}"
        else
            Send "^{End}"
    }
    
    ; --- Function Key Navigation ---
    static SendFunctionKey(number) {
        this.sendKey("F" number)
    }
    
    ; --- Legacy Support ---
    static sendNavKey(key) {
        this.sendKey(key)
    }
    
    static sendCtrlNav(direction) {
        if GetKeyState("Shift", "P")
            Send "^+{" direction "}"
        else
            Send "^{" direction "}"
    }
}
```

### keyb_lib.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- Shared Library for AutoHotkey Keyboard Enhancement Scripts ---

; Include navigation library
#Include %A_ScriptDir%\nav_lib.ahk

class KeybLib {
    ; --- State Management ---
    static NavModeEnabled := false
    static VimModeEnabled := false
    
    ; --- Mode Display Management ---
    static StatusBarVisible := false
    static StatusGui := Gui()
    
    ; --- Clipboard Handling ---
    static OldClipboard := ""
    
    ; --- Mode Display Functions ---
    static ShowTooltip(message, duration := 1500) {
        ToolTip message, 10, 10
        SetTimer () => ToolTip(), -duration
    }
    
    static ShowModeStatus(mode) {
        if (this.StatusBarVisible) {
            this.StatusGui.Destroy()
        }
        
        modeColor := "00FF00"  ; Default for Insert
        if (mode = "Normal")
            modeColor := "0000FF"
        else if (mode = "Visual")
            modeColor := "FF0000"
        else if (mode = "Navigation")
            modeColor := "00FFFF"
        
        this.StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
        this.StatusGui.BackColor := modeColor
        this.StatusGui.SetFont("s10 c" . (mode = "Normal" ? "FFFFFF" : "000000"), "Arial")
        this.StatusGui.Add("Text", "w100 Center", mode . " MODE")
        this.StatusGui.Show("NoActivate y0")
        this.StatusBarVisible := true
        
        SetTimer () => this.HideStatusBar(), -1500
    }
    
    static HideStatusBar() {
        this.StatusGui.Destroy()
        this.StatusBarVisible := false
    }
    
    ; --- Clipboard Management ---
    static SaveClipboard() {
        this.OldClipboard := ClipboardAll()
        A_Clipboard := ""
    }
    
    static RestoreClipboard() {
        A_Clipboard := this.OldClipboard
        this.OldClipboard := ""
    }
    
    ; --- Navigation Functions ---
    ; These functions now delegate to NavLib
    static sendNavKey(key) {
        NavLib.sendNavKey(key)
    }
    
    static sendCtrlNav(direction) {
        NavLib.sendCtrlNav(direction)
    }
    
    ; --- Toggle Functions ---
    static ToggleNavMode() {
        this.NavModeEnabled := !this.NavModeEnabled
        if (this.NavModeEnabled) {
            this.VimModeEnabled := false
            this.ShowTooltip("Navigation Mode: ON")
            this.ShowModeStatus("Navigation")
        } else {
            this.ShowTooltip("Navigation Mode: OFF")
        }
        return this.NavModeEnabled
    }
    
    static ToggleVimMode() {
        this.VimModeEnabled := !this.VimModeEnabled
        if (this.VimModeEnabled) {
            this.NavModeEnabled := false
            this.ShowTooltip("Vim Mode: ON")
            this.ShowModeStatus("Normal")
        } else {
            this.ShowTooltip("Vim Mode: OFF")
        }
        return this.VimModeEnabled
    }
    
    static ToggleCapsLock() {
        currentState := GetKeyState("CapsLock", "T")
        SetCapsLockState !currentState
        return !currentState
    }
}
```

### vim_lib.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- Shared Library for Vim Functionality ---
; Extends keyb_lib.ahk with Vim-specific functionality

; Include the base keyboard library (which includes nav_lib.ahk)
#Include %A_ScriptDir%\keyb_lib.ahk

class VimLib {
    ; --- Mode Tracking ---
    static VimMode := "Normal"  ; "Normal", "Insert", "Visual"
    
    ; --- Mode Status Display Functions ---
    static ShowModeStatus(mode := "") {
        if (mode = "")
            mode := this.VimMode
            
        ; Reuse the base tooltip functionality but with Vim-specific colors
        modeColor := "00FF00"  ; Default for Insert
        if (mode = "Normal")
            modeColor := "0000FF"
        else if (mode = "Visual")
            modeColor := "FF0000"
        
        ; Reuse the StatusGui from KeybLib
        if (KeybLib.StatusBarVisible) {
            KeybLib.StatusGui.Destroy()
        }
        
        KeybLib.StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
        KeybLib.StatusGui.BackColor := modeColor
        KeybLib.StatusGui.SetFont("s10 c" . (mode = "Normal" ? "FFFFFF" : "000000"), "Arial")
        KeybLib.StatusGui.Add("Text", "w100 Center", mode . " MODE")
        KeybLib.StatusGui.Show("NoActivate y0")
        KeybLib.StatusBarVisible := true
        
        SetTimer () => KeybLib.HideStatusBar(), -1500
    }
    
    ; --- Mode Changes ---
    static SwitchToNormal() {
        this.VimMode := "Normal"
        this.ShowModeStatus()
    }
    
    static SwitchToInsert() {
        this.VimMode := "Insert"
        this.ShowModeStatus()
    }
    
    static SwitchToVisual() {
        this.VimMode := "Visual"
        this.ShowModeStatus()
    }
    
    ; --- Common Vim Commands ---
    static DeleteLine() {
        KeybLib.SaveClipboard()
        NavLib.MoveToLineStart()
        Send "+{End}^x"
        KeybLib.RestoreClipboard()
    }
    
    static YankLine() {
        KeybLib.SaveClipboard()
        NavLib.MoveToLineStart()
        Send "+{End}^c{Right}"
        KeybLib.RestoreClipboard()
    }
    
    static Paste() {
        KeybLib.SaveClipboard()
        Send "^v"
        KeybLib.RestoreClipboard()
    }
    
    static PasteBefore() {
        KeybLib.SaveClipboard()
        NavLib.MoveLeft()
        Send "^v"
        KeybLib.RestoreClipboard()
    }
    
    ; --- Vim Text Operations ---
    static ChangeToLineEnd() {
        KeybLib.SaveClipboard()
        Send "+{End}^x"
        this.SwitchToInsert()
        KeybLib.RestoreClipboard()
    }
    
    static DeleteWord() {
        KeybLib.SaveClipboard()
        Send "^+{Right}^x"
        KeybLib.RestoreClipboard()
    }
    
    static ChangeWord() {
        KeybLib.SaveClipboard()
        Send "^+{Right}^x"
        this.SwitchToInsert()
        KeybLib.RestoreClipboard()
    }
    
    static OpenLineBelow() {
        NavLib.MoveToLineEnd()
        Send "{Enter}"
        this.SwitchToInsert()
    }
    
    static OpenLineAbove() {
        NavLib.MoveToLineStart()
        Send "{Enter}{Up}"
        this.SwitchToInsert()
    }
}
```

## Main Scripts

### keyb60.ahk

```autohotkey
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

### keyb60vim.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- CapsLock Modifier for 60% Keyboard with Vim-Style Navigation ---
; --- CapsLock with Numbers for fn keys ---
; --- Win+J to toggle Navigation Mode, Win+V to toggle Vim Mode ---

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

; Navigation mode hotkeys - active when NavMode is on and VimMode is off
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
```

### vim.ahk

```autohotkey
#Requires AutoHotkey v2.0+
; --- Vim Emulation Script ---
; A more comprehensive Vim emulation for Windows applications

; Include vim library (which also includes keyb_lib.ahk)
#Include %A_ScriptDir%\vim_lib.ahk
#SingleInstance Force

; Initialize Vim in Normal mode
VimLib.SwitchToNormal()

; --- Core Mode Switching ---
Escape:: {
    VimLib.SwitchToNormal()
}

; --- Normal Mode Commands ---
#HotIf (VimLib.VimMode = "Normal")
    ; Mode switches
    i:: VimLib.SwitchToInsert()
    +i:: {
        Send("{Home}")
        VimLib.SwitchToInsert()
    }
    a:: {
        Send("{Right}")
        VimLib.SwitchToInsert()
    }
    +a:: {
        Send("{End}")
        VimLib.SwitchToInsert()
    }
    v:: VimLib.SwitchToVisual()
    
    ; Basic navigation
    h:: Send("{Left}")
    j:: Send("{Down}")
    k:: Send("{Up}")
    l:: Send("{Right}")
    
    ; Word navigation
    w:: Send("^{Right}")
    e:: {
        Send("^{Right}")
        Send("{Left}")
    }
    b:: Send("^{Left}")
    
    ; Line navigation
    0:: Send("{Home}")
    $:: Send("{End}")
    ^:: {
        Send("{Home}")
        ; Skip leading whitespace
        Loop {
            if !GetKeyState("Space", "P")
                break
            Send("{Right}")
        }
    }
    
    ; Page navigation
    ^f:: Send("{PgDn}")
    ^b:: Send("{PgUp}")
    ^d:: Send("{PgDn}")
    ^u:: Send("{PgUp}")
    
    ; Document navigation
    g:: {
        if A_PriorHotkey = "g" && A_TimeSincePriorHotkey < 400
            Send("^{Home}")
    }
    +g:: Send("^{End}")
    
    ; Editing - character operations
    x:: Send("{Delete}")
    +x:: Send("{BackSpace}")
    r:: {
        Input := InputHook("L1")
        Input.Start()
        Input.Wait()
        Send(Input.Input)
    }
    
    ; Editing - line operations
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
    
    ; Compound editing commands
    s:: {
        Send("{Delete}")
        VimLib.SwitchToInsert()
    }
    c:: {
        if A_PriorHotkey = "c" && A_TimeSincePriorHotkey < 400 {
            Send("{Home}+{End}{Delete}")
            VimLib.SwitchToInsert()
        }
    }
    +c:: {
        Send("+{End}^x")
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
    
    ; Search and replace
    /:: Send("^f")
    *:: {
        ; Search for word under cursor
        VimLib.SaveClipboard()
        Send("^{Left}+^{Right}^c")
        Send("^f")
        Send("^v")
        VimLib.RestoreClipboard()
    }
    
    ; Other
    ; Toggle case
    ~:: {
        VimLib.SaveClipboard()
        Send("{Right}+{Left}^c")
        clipContent := A_Clipboard
        if (clipContent == Format("{:U}", clipContent))
            A_Clipboard := Format("{:L}", clipContent)
        else
            A_Clipboard := Format("{:U}", clipContent)
        Send("^v")
        VimLib.RestoreClipboard()
    }
    
    ; Macros (basic implementation)
    q:: {
        VimLib.ShowTooltip("Macro recording not implemented")
    }
#HotIf

; --- Visual Mode Commands ---
#HotIf (VimLib.VimMode = "Visual")
    ; Navigation with selection
    h:: Send("+{Left}")
    j:: Send("+{Down}")
    k:: Send("+{Up}")
    l:: Send("+{Right}")
    
    ; Word navigation with selection
    w:: Send("+^{Right}")
    e:: {
        Send("+^{Right}+{Left}")
    }
    b:: Send("+^{Left}")
    
    ; Line navigation with selection
    0:: Send("+{Home}")
    $:: Send("+{End}")
    
    ; Page navigation with selection
    ^f:: Send("+{PgDn}")
    ^b:: Send("+{PgUp}")
    ^d:: Send("+{PgDn}")
    ^u:: Send("+{PgUp}")
    
    ; Document navigation with selection
    g:: {
        if A_PriorHotkey = "g" && A_TimeSincePriorHotkey < 400
            Send("+^{Home}")
    }
    +g:: Send("+^{End}")
    
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
    c:: {
        VimLib.SaveClipboard()
        Send("^x")
        VimLib.SwitchToInsert()
        VimLib.RestoreClipboard()
    }
    
    ; Indentation
    >:: {
        VimLib.SaveClipboard()
        Send("^c")
        indented := RegExReplace(A_Clipboard, "m)^", "`t")
        A_Clipboard := indented
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
    <:: {
        VimLib.SaveClipboard()
        Send("^c")
        unindented := RegExReplace(A_Clipboard, "m)^\t", "")
        A_Clipboard := unindented
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
    
    ; Case changing
    u:: {
        VimLib.SaveClipboard()
        Send("^c")
        A_Clipboard := Format("{:L}", A_Clipboard)
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
    +u:: {
        VimLib.SaveClipboard()
        Send("^c")
        A_Clipboard := Format("{:U}", A_Clipboard)
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
#HotIf

; --- Insert Mode allows typing normally ---
#HotIf (VimLib.VimMode = "Insert")
    ; Insert mode has no hotkeys except Escape, which is handled globally
#HotIf
```

## Usage

These scripts provide enhanced functionality for 60% keyboards, with focus on:

1. **Keyboard Navigation** - Arrow keys, page navigation, and text editing without leaving the home row
2. **Vim Emulation** - Vim-style text editing with modal interface
3. **Hybrid Mode** - Combination of custom navigation and Vim commands

### Setup Instructions

1. Install AutoHotkey v2.0 or higher
2. Save all script files to the same directory
3. Run the desired main script:
   - `keyb60.ahk` - Basic navigation enhancements
   - `keyb60vim.ahk` - Navigation with Vim-inspired commands
   - `vim.ahk` - Full Vim emulation

### Key Controls

- **Win+J** - Toggle Navigation Mode
- **Win+V** - Toggle Vim Mode (in keyb60vim.ahk)
- **Win+CapsLock** - Toggle physical CapsLock state
- **CapsLock** (held) - Activate navigation keys temporarily

## Customization

The modular nature of these scripts allows for easy customization:

1. Edit `nav_lib.ahk` to change navigation behavior
2. Edit `vim_lib.ahk` to modify Vim command functionality
3. Edit the main scripts to change key mappings

## Future Enhancements

Potential enhancements to consider:

1. Additional text manipulation commands
2. Custom macro recording
3. Application-specific bindings
4. Linux port using KeyD