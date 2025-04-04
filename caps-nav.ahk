#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"
*CapsLock::Return

;+CapsLock toggles CapsLock state explicitly
#CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState  ; Toggle CapsLock state
}

; Activate hotkeys only when CapsLock is held
#HotIf GetKeyState("CapsLock", "P")
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

#HotIf

; Function to handle modifiers and send keys
sendNavKey(key) {
    mods := ""
    if GetKeyState("Ctrl", "P") {
        mods .= "^"  ; Ctrl
    }
    if GetKeyState("Shift", "P") {
        mods .= "+"  ; Shift
    }
    Send mods "{" key "}"
}

; Function specifically for Ctrl navigation keys with optional Shift
sendCtrlNav(key) {
    mods := "^"
    if GetKeyState("Shift", "P") {
        mods .= "+"
    }
    Send mods "{" key "}"
}