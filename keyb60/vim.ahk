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
    
    modeColor := "00FF00"  ; Green for Insert mode
    if (VimMode = "Normal")
        modeColor := "0000FF"  ; Blue for Normal mode
    else if (VimMode = "Visual")
        modeColor := "FF0000"  ; Red for Visual mode
    
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

; Save current clipboard content
SaveClipboard() {
    global OldClipboard
    OldClipboard := ClipboardAll()
    A_Clipboard := ""
    return
}

; Restore clipboard to its previous state
RestoreClipboard() {
    global OldClipboard
    A_Clipboard := OldClipboard
    OldClipboard := ""
    return
}

; ===== Mode Switching =====
; Switch to Normal Mode with Escape
Escape:: {
    global VimMode
    VimMode := "Normal"
    ShowMode()
}

; ===== NORMAL MODE COMMANDS =====
#HotIf (VimMode = "Normal")
    ; Switch to Insert Mode with 'i'
    i:: {
        global VimMode
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Switch to Visual Mode with 'v'
    v:: {
        global VimMode
        VimMode := "Visual"
        ShowMode()
    }

    ; === Basic Movement ===
    h:: Send("{Left}")
    j:: Send("{Down}")
    k:: Send("{Up}")
    l:: Send("{Right}")
    
    ; === Word Movement ===
    w:: Send("^{Right}")  ; Next word
    b:: Send("^{Left}")   ; Previous word
    
    ; === Line Navigation ===
    0:: Send("{Home}")    ; Beginning of line
    $:: Send("{End}")     ; End of line
    
    ; === Page Navigation ===
    ^u:: Send("{PgUp}")   ; Page up
    ^d:: Send("{PgDn}")   ; Page down
    
    ; === Document Navigation ===
    g:: {
        if A_PriorHotkey = "g" && A_TimeSincePriorHotkey < 400
            Send("^{Home}")  ; Top of document (gg)
    }
    +g:: Send("^{End}")    ; Bottom of document
    
    ; === Editing Commands ===
    x:: Send("{Delete}")  ; Delete character
    
    ; Delete and enter insert mode
    s:: {
        Send("{Delete}")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Delete line
    d:: {
        if A_PriorHotkey = "d" && A_TimeSincePriorHotkey < 400 {
            SaveClipboard()
            Send("{Home}+{End}^x")
            RestoreClipboard()
        }
    }
    
    ; Yank (copy) line
    y:: {
        if A_PriorHotkey = "y" && A_TimeSincePriorHotkey < 400 {
            SaveClipboard()
            Send("{Home}+{End}^c{Right}")
            RestoreClipboard()
        }
    }
    
    ; Paste after cursor
    p:: {
        SaveClipboard()
        Send("^v")
        RestoreClipboard()
    }
    
    ; Paste before cursor
    +p:: {
        SaveClipboard()
        Send("{Left}^v")
        RestoreClipboard()
    }
    
    ; Undo
    u:: Send("^z")
    
    ; Redo
    ^r:: Send("^y")
    
    ; Find
    /:: Send("^f")
    
    ; Insert at beginning of line
    +i:: {
        Send("{Home}")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Insert at end of line
    +a:: {
        Send("{End}")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Open line below and enter insert mode
    o:: {
        Send("{End}{Enter}")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Open line above and enter insert mode
    +o:: {
        Send("{Home}{Enter}{Up}")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Change until end of line
    +c:: {
        Send("+{End}^x")
        VimMode := "Insert"
        ShowMode()
    }
    
    ; Replace single character
    r:: {
        Input := InputHook("L1")
        Input.Start()
        Input.Wait()
        Send(Input.Input)
    }
#HotIf

; ===== VISUAL MODE COMMANDS =====
#HotIf (VimMode = "Visual")
    ; === Movement - extends selection ===
    h:: Send("+{Left}")
    j:: Send("+{Down}")
    k:: Send("+{Up}")
    l:: Send("+{Right}")
    
    ; === Word Movement ===
    w:: Send("+^{Right}")  ; Next word
    b:: Send("+^{Left}")   ; Previous word
    
    ; === Line Navigation ===
    0:: Send("+{Home}")    ; Beginning of line
    $:: Send("+{End}")     ; End of line
    
    ; === Copy and cut ===
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
    
    ; Delete selection
    x:: {
        Send("{Delete}")
        VimMode := "Normal"
        ShowMode()
    }
#HotIf

; ===== Initialize =====
; Start in Normal Mode by default
VimMode := "Normal"
ShowMode()