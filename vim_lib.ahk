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