#Requires AutoHotkey v2.0+
; --- Shared Library Functions for key60 AHK Scripts ---

; Helper function to send navigation keys with modifier support
sendNavKey(key) {
    modString := ""
    
    ; Add modifiers to string based on key state
    if GetKeyState("Shift", "P")
        modString .= "+"
    if GetKeyState("Ctrl", "P")
        modString .= "^"
    if GetKeyState("Alt", "P")
        modString .= "!"
    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
        modString .= "#"
        
    ; Send the modified key
    Send modString . "{" . key . "}"
    return
}

; Helper function for Ctrl+direction navigation (for word jumps)
sendCtrlNav(direction) {
    modString := "^"  ; Start with Ctrl modifier
    
    ; Add Shift modifier if Shift is pressed
    if GetKeyState("Shift", "P")
        modString .= "+"
        
    ; Send the key with modifiers
    Send modString . "{" . direction . "}"
    return
}

; Status indicator variables
global StatusGui := Gui()
global StatusVisible := false

; Function to show a tooltip with auto-dismiss
showTooltip(text, duration := 1500) {
    ToolTip text, 10, 10
    SetTimer () => ToolTip(), -duration
}

; Enhanced status indicator that shows current mode
showModeStatus(mode, color := "0066CC") {
    global StatusGui, StatusVisible
    
    ; Colors for different modes
    colorMap := Map(
        "NAV", "0066CC",     ; Blue
        "VIM", "990000",     ; Dark Red
        "APP", "006600",     ; Green
        "MAC", "CC6600"      ; Orange
    )
    
    ; Get color if it's in our map
    if colorMap.Has(mode)
        color := colorMap[mode]
    
    ; Destroy existing status if visible
    if (StatusVisible) {
        StatusGui.Destroy()
    }
    
    ; Create new status indicator
    StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    StatusGui.BackColor := color
    StatusGui.SetFont("s10 cFFFFFF bold", "Segoe UI")
    StatusGui.Add("Text", "w60 h30 Center", mode)
    
    ; Show in bottom right corner of main monitor
    monitorWidth := A_ScreenWidth
    monitorHeight := A_ScreenHeight
    xPos := monitorWidth - 70
    yPos := monitorHeight - 50
    StatusGui.Show("NoActivate x" . xPos . " y" . yPos)
    
    StatusVisible := true
}

; Hide the status indicator
hideModeStatus() {
    global StatusGui, StatusVisible
    
    if (StatusVisible) {
        StatusGui.Destroy()
        StatusVisible := false
    }
}