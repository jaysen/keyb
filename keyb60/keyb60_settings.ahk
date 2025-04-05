#Requires AutoHotkey v2.0+
; --- Keyboard Master Customization Settings ---
; This file contains user-customizable settings for the keyboard_master.ahk script

; ===== Mode Toggle Hotkeys =====
; Modify these to change which key combinations activate different modes
global HOTKEYS := Map(
    "NavMode", "#j",          ; Win+J toggles Navigation mode
    "VimMode", "#v",          ; Win+V toggles Vim mode
    "AppLauncher", "#a",      ; Win+A toggles App Launcher mode
    "MacroMode", "#m",        ; Win+M toggles Macro mode
    "ToggleCapsLock", "#CapsLock"  ; Win+CapsLock toggles CapsLock state
)

; ===== Visual Settings =====
global VISUALS := Map(
    "ShowTooltips", true,           ; Show tooltips on mode changes
    "TooltipDuration", 1500,        ; How long tooltips remain visible (ms)
    "ShowModeIndicator", true,      ; Show persistent mode indicator
    "IndicatorPosition", "bottomright", ; Position: "topleft", "topright", "bottomleft", "bottomright"
    "NavModeColor", "0066CC",       ; Navigation mode color (hex)
    "VimModeColor", "990000",       ; Vim mode color (hex)
    "AppLauncherColor", "006600",   ; App launcher mode color (hex)
    "MacroModeColor", "CC6600"      ; Macro mode color (hex)
)

; ===== App Launcher Shortcuts =====
; Customize which applications are launched in App Launcher mode
global APPS := Map(
    "c", "calc.exe",                  ; Calculator
    "n", "notepad.exe",               ; Notepad 
    "b", "msedge.exe",                ; Edge browser
    "f", "explorer.exe",              ; File Explorer
    "w", "winword.exe",               ; Microsoft Word
    "e", "excel.exe",                 ; Microsoft Excel
    "v", "code.exe",                  ; Visual Studio Code
    "t", "wt.exe",                    ; Windows Terminal
    
    ; Additional apps - customize these to your preference
    "g", "git-bash.exe",              ; Git Bash
    "p", "powershell.exe",            ; PowerShell
    "s", "https://stackoverflow.com/", ; Stack Overflow
    "d", "devenv.exe",                ; Visual Studio
    "m", "mailto:",                   ; Default email client
    "k", "taskmgr.exe",               ; Task Manager
    "l", "ms-settings:",              ; Windows Settings
    "j", "appwiz.cpl"                 ; Add/Remove Programs
)

; ===== Macro Text Expansion =====
; Customize text snippets for Macro mode
global MACROS := Map(
    "d", FormatTime(, "yyyy-MM-dd"),        ; Current date
    "t", FormatTime(, "HH:mm:ss"),          ; Current time
    
    ; Customize these with your personal information
    "e", "your@email.com",                   ; Your email
    "s", "Sincerely,`nYour Name",            ; Signature
    "a", "Your Full Address`nCity, State ZIP", ; Address
    
    ; Common phrases - add your own frequently used text
    "1", "Thank you for your message. I'll get back to you as soon as possible.",
    "2", "I hope this email finds you well.",
    "3", "Please let me know if you have any questions."
)

; ===== Navigation Mode Customization =====
; Set to true for keys you want enabled in Navigation mode
global NAV_KEYS := Map(
    "EnableWASD", true,          ; WASD arrow keys
    "EnableIJKL", true,          ; IJKL arrow keys
    "EnableMouseControl", true,  ; Mouse movement with QWER
    "ScrollSpeed", 3             ; Mouse wheel scroll speed
)