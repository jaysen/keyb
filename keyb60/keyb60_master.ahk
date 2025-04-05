#Requires AutoHotkey v2.0+
; ========================================================
; KEYBOARD MASTER - Comprehensive keyboard enhancement script
; For 60%/70% mechanical keyboards
; ========================================================

; --- Settings and Configuration ---
; Include shared library functions
#Include keyb60_lib.ahk

; Global state variables
global NavModeEnabled := false      ; Navigation mode (arrow keys, etc.)
global VimModeEnabled := false      ; Vim emulation
global AppLauncherMode := false     ; For app launching hotkeys
global MacroMode := false           ; For text expansion/macros

; Configuration options - modify these to your preference
global CONFIG := Map(
    "ShowTooltips", true,           ; Whether to show tooltips on mode changes
    "TooltipDuration", 1500,        ; How long tooltips remain visible (ms)
    "StatusBarLocation", "top",     ; Where to show the Vim status bar (top, bottom)
    "AppLauncherKey", "#a",         ; Win+A activates app launcher mode
    "MacroKey", "#m"                ; Win+M activates macro mode
)

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; --- Mode Toggle Hotkeys ---

; Win+J toggles navigation mode
#j::
{
    global NavModeEnabled, VimModeEnabled, MacroMode, AppLauncherMode
    NavModeEnabled := !NavModeEnabled
    
    if (NavModeEnabled) {
        VimModeEnabled := false
        MacroMode := false
        AppLauncherMode := false
        showTooltip("Navigation Mode: ON")
        showModeStatus("NAV")
    } else {
        showTooltip("Navigation Mode: OFF")
        hideModeStatus()
    }
}

; Win+V toggles Vim mode
#v::
{
    global VimModeEnabled, NavModeEnabled, MacroMode, AppLauncherMode
    VimModeEnabled := !VimModeEnabled
    
    if (VimModeEnabled) {
        NavModeEnabled := false
        MacroMode := false
        AppLauncherMode := false
        showTooltip("Vim Mode: ON")
        showModeStatus("VIM")
    } else {
        showTooltip("Vim Mode: OFF")
        hideModeStatus()
    }
}

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState
    
    if GetKeyState("CapsLock", "T")
        showTooltip("CapsLock: ON")
    else
        showTooltip("CapsLock: OFF")
}

; Win+A toggles App Launcher mode
#a::
{
    global AppLauncherMode, NavModeEnabled, VimModeEnabled, MacroMode
    AppLauncherMode := !AppLauncherMode
    
    if (AppLauncherMode) {
        NavModeEnabled := false
        VimModeEnabled := false
        MacroMode := false
        showTooltip("App Launcher Mode: ON")
        showModeStatus("APP")
    } else {
        showTooltip("App Launcher Mode: OFF")
        hideModeStatus()
    }
}

; Win+M toggles Macro mode
#m::
{
    global MacroMode, NavModeEnabled, VimModeEnabled, AppLauncherMode
    MacroMode := !MacroMode
    
    if (MacroMode) {
        NavModeEnabled := false
        VimModeEnabled := false
        AppLauncherMode := false
        showTooltip("Macro Mode: ON")
        showModeStatus("MAC")
    } else {
        showTooltip("Macro Mode: OFF")
        hideModeStatus()
    }
}

; --- Navigation Mode Hotkeys ---
#HotIf (GetKeyState("CapsLock", "P") or NavModeEnabled) and !VimModeEnabled and !AppLauncherMode and !MacroMode
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
    
    ; Enhanced arrow key combinations
    *e::sendNavKey("End")    ; Alternative to '
    *q::sendNavKey("Home")   ; Alternative to h
    
    ; Media controls and system keys
    *[::Send("{Volume_Down}")
    *]::Send("{Volume_Up}")
    *\::Send("{Volume_Mute}")
    *BackSpace::Send("{Delete}")
    *Enter::Send("{Insert}")    ; Insert key is often missing on 60% keyboards
    
    ; Window management shortcuts
    *z::Send("#{Left}")         ; Snap window to left
    *x::Send("#{Right}")        ; Snap window to right
    *c::Send("#{Down}")         ; Minimize window
    *v::Send("#{Up}")           ; Maximize window
    *b::Send("!{Tab}")          ; Alt+Tab for window switching
    
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
    $;::Return
#HotIf

; --- App Launcher Mode Hotkeys ---
#HotIf AppLauncherMode
    ; Common applications
    c::Run("calc.exe")               ; Calculator
    n::Run("notepad.exe")            ; Notepad
    b::Run("msedge.exe")             ; Edge Browser
    f::Run("explorer.exe")           ; File Explorer
    w::Run("winword.exe")            ; Word
    e::Run("excel.exe")              ; Excel
    v::Run("code.exe")               ; Visual Studio Code
    t::Run("wt.exe")                 ; Windows Terminal
    
    ; Development tools
    g::Run("git-bash.exe")           ; Git Bash
    p::Run("powershell.exe")         ; PowerShell
    s::Run("https://stackoverflow.com/") ; Stack Overflow
    d::Run("devenv.exe")             ; Visual Studio
    
    ; Utilities
    m::Run("mailto:")                ; Default email client
    k::Run("taskmgr.exe")            ; Task Manager
    l::Run("ms-settings:")           ; Windows Settings
    j::Run("appwiz.cpl")             ; Add/Remove Programs
    
    ; Toggle back to normal mode after launching an app
    c up::
    n up::
    b up::
    f up::
    w up::
    e up::
    v up::
    t up::
    g up::
    p up::
    s up::
    d up::
    m up::
    k up::
    l up::
    j up::
    {
        global AppLauncherMode
        AppLauncherMode := false
        showTooltip("App Launcher Mode: OFF")
        hideModeStatus()
    }
#HotIf

; --- Macro Mode Hotkeys ---
#HotIf MacroMode
    ; Text expansion snippets
    d::SendText(FormatTime(, "yyyy-MM-dd"))        ; Current date
    t::SendText(FormatTime(, "HH:mm:ss"))          ; Current time
    e::SendText("your@email.com")                  ; Your email
    s::SendText("Sincerely,`nYour Name")           ; Signature
    a::SendText("Your Full Address`nCity, State ZIP") ; Address
    
    ; Common phrases
    1::SendText("Thank you for your message. I'll get back to you as soon as possible.")
    2::SendText("I hope this email finds you well.")
    3::SendText("Please let me know if you have any questions.")
    
    ; Toggle back to normal mode after using a macro
    d up::
    t up::
    e up::
    s up::
    a up::
    1 up::
    2 up::
    3 up::
    {
        global MacroMode
        MacroMode := false
        showTooltip("Macro Mode: OFF")
        hideModeStatus()
    }
#HotIf

; --- Vim Mode ---
; Include the Vim script when Vim mode is enabled
#HotIf VimModeEnabled
    #Include vim.ahk
#HotIf

; --- Custom Mouse Controls (when in Navigation Mode) ---
#HotIf NavModeEnabled
    ; Left side of keyboard controls mouse movement
    *q:: MouseMove(-10, 0, 2, "R")    ; Move mouse left
    *w:: MouseMove(0, -10, 2, "R")    ; Move mouse up
    *e:: MouseMove(0, 10, 2, "R")     ; Move mouse down
    *r:: MouseMove(10, 0, 2, "R")     ; Move mouse right
    
    ; Mouse buttons
    *f:: Click()                      ; Left click
    *g:: Click("right")               ; Right click
    *t:: Click("middle")              ; Middle click
    
    ; Scrolling
    *z:: Click("WheelUp", 3)          ; Scroll up
    *x:: Click("WheelDown", 3)        ; Scroll down
#HotIf

; --- Initialize Script ---
showTooltip("Keyboard Master loaded! Use Win+J for Nav, Win+V for Vim, Win+A for Apps, Win+M for Macros", 3000)

; Start with clean status
hideModeStatus()