#Requires AutoHotkey v2.0+
; --- Vim Emulation Script ---
; A more comprehensive Vim emulation for Windows applications

; Include vim library (which also includes keyb_lib)
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
        ; Cut the selected text (Ctrl+X), switch to Insert mode, and restore the clipboard
        VimLib.SaveClipboard()
        Send("^x")
        VimLib.SwitchToInsert()
        VimLib.RestoreClipboard()
    }
    
    ; Indentation
    >:: {
        ; Indent the selected text by adding a tab character at the beginning of each line
        VimLib.SaveClipboard()
        Send("^c")
        indented := RegExReplace(A_Clipboard, "m)^", "`t")
        A_Clipboard := indented
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
    <:: {
        ; Unindent the selected text by removing a tab character from the beginning of each line
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
        ; Convert the selected text to lowercase
        VimLib.SaveClipboard()
        Send("^c")
        A_Clipboard := Format("{:L}", A_Clipboard)
        Send("^v")
        VimLib.RestoreClipboard()
        VimLib.SwitchToNormal()
    }
    +u:: {
        ; Convert the selected text to uppercase
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