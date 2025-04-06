#Requires AutoHotkey v2.0+
; --- Shared Library for AutoHotkey Keyboard Enhancement Scripts ---

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

    ; --- Double-Tap Detection ---
    static lastCapsLockTime := 0
    static capsLockTapCount := 0
    static doubleTapThreshold := 400  ; milliseconds

    ; Detects double-tapping of CapsLock
    static DetectCapsLockDoubleTap() {
        currentTime := A_TickCount
        timeSinceLast := currentTime - this.lastCapsLockTime
        
        ; Reset tap count if it's been too long since last tap
        if (timeSinceLast > this.doubleTapThreshold) {
            this.capsLockTapCount := 1
        } else {
            this.capsLockTapCount += 1
        }
        
        this.lastCapsLockTime := currentTime
        
        ; Return true if double-tapped
        return (this.capsLockTapCount >= 2)
    }

    ; Reset the tap counter (used when processing a successful double-tap)
    static ResetCapsLockTapCount() {
        this.capsLockTapCount := 0
    }
}