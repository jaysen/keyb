#Requires AutoHotkey v2.0+
; --- Keyboard Master Launcher ---
; Main entry point for the keyboard enhancement system

; Set working directory to script location
SetWorkingDir "C:\Users\JaysenNaidoo\repos\projects\ahk\keyb60"

; Load the settings first
#Include keyb60_settings.ahk

; Load the library functions
#Include keyb60_lib.ahk

; Check for first run/configuration
if !FileExist("keyboard_settings.ahk")
{
    MsgBox "Welcome to Keyboard Master!`n`nThis appears to be your first run. A default configuration file has been created.`n`nYou can customize your setup by editing keyboard_settings.ahk", "First Run Setup"
    
    ; Create default settings file
    FileAppend "#Requires AutoHotkey v2.0+`n; Default settings file`n`n", "keyboard_settings.ahk"
}

; Load the main script
#Include keyb60_master.ahk

; Display startup message
showTooltip("Keyboard Master loaded! Use Win+J for Nav, Win+V for Vim, Win+A for Apps, Win+M for Macros", 3000)

; Set up tray menu
A_TrayMenu.Add "Keyboard Master Settings", ShowSettings
A_TrayMenu.Add
A_TrayMenu.Add "About", ShowAbout
A_TrayMenu.Default := "Keyboard Master Settings"

; Function to open settings file
ShowSettings(ItemName, ItemPos, MyMenu) {
    Run "notepad.exe keyboard_settings.ahk"
}

; Function to show about dialog
ShowAbout(ItemName, ItemPos, MyMenu) {
    MsgBox "Keyboard Master`nVersion 1.0`n`nA comprehensive keyboard enhancement system for 60%/70% mechanical keyboards.`n`nUse Win+J to toggle Navigation mode`nUse Win+V to toggle Vim mode`nUse Win+A to toggle App Launcher`nUse Win+M to toggle Macro mode", "About Keyboard Master"
}