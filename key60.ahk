#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---
; --- CapsLock with Numbers for fn keys ---

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"
*CapsLock::Return

;+CapsLock toggles CapsLock state explicitly
+CapsLock::
{
    currentState := GetKeyState("CapsLock", "T")
    SetCapsLockState !currentState  ; Toggle CapsLock state
}

; Activate hotkeys when CapsLock is held or toggled on
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
    *`;::sendNavKey("End")
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

#HotIf


; Function to handle modifiers and send keys
sendNavKey(key) {
    mods := ""
    if GetKeyState("Ctrl", "P") {
        mods .= "^"
    }
    if GetKeyState("Shift", "P") {
        mods .= "+"
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

