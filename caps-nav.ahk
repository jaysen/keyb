#Requires AutoHotkey v2.0+
; --- CapsLock Modifier (WASD/IJKL + HYU and NM for navigation) ---

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"
*CapsLock::Return

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
    *`;::sendNavKey("End")
    *p::sendNavKey("PgUp")
    */::sendNavKey("PgDn")

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
