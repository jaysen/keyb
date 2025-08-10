#Requires AutoHotkey v2.0+
; --- CapsLock Modifier layer matching updated keyd default.conf ---
; --- CapsLock with Numbers for fn keys ---
; --- CapsLock Modifier with Toggle Navigation Mode ---

; Include the shared library
#Include ..\shared\keyb_lib.ahk
#Include ..\shared\text_lib.ahk
#Include ..\shared\nav_lib.ahk
#Include ..\shared\text_lib.ahk
#SingleInstance Force

; Prevent CapsLock from toggling
SetCapsLockState "AlwaysOff"

; Win+J toggles navigation mode
#j::
{
    KeybLib.ToggleNavMode(true)
}

; Handle CapsLock tap (without modifiers)
*CapsLock::
{
    ; Wait for the key to be released
    KeyWait "CapsLock"
    
    ; Check if it was a double-tap
    if (KeybLib.DetectCapsLockDoubleTap()) {
        ; Double tap detected, toggle navigation mode on
        if (!KeybLib.NavModeEnabled) {
            KeybLib.ToggleNavMode(true)
        }
        KeybLib.ResetCapsLockTapCount()
    } else if (KeybLib.NavModeEnabled) {
        ; Single tap while in nav mode - exit nav mode
        KeybLib.ToggleNavMode()
    }
    ; Otherwise do nothing, allowing CapsLock to be used as a modifier when held
}

; While NavMode is enabled, Esc exits NavMode
#HotIf KeybLib.NavModeEnabled
Escape::
{
    KeybLib.ToggleNavMode()
}
#HotIf

; Active when CapsLock is held OR NavMode is enabled
#HotIf GetKeyState("CapsLock", "P") or KeybLib.NavModeEnabled

; ===== Delete / Backspace =====
*q::Send "{Delete}"        ; q = delete
*Tab::Send "{Backspace}"   ; tab = backspace

; ===== WASD arrows (+ E up) =====
*w::NavLib.MoveUp()
*a::NavLib.MoveLeft()
*s::NavLib.MoveDown()
*d::NavLib.MoveRight()
*e::NavLib.MoveUp()        ; e = up

; ===== IJKL arrows =====
*i::NavLib.MoveUp()
*j::NavLib.MoveLeft()
*k::NavLib.MoveDown()
*l::NavLib.MoveRight()

; ===== Word back/fwd - RIGHT CENTRE =====
*h::Send "^{Left}"         ; h = Ctrl+Left
*;::Send "^{Right}"        ; semicolon = Ctrl+Right
*'::Send "^{Right}"        ; apostrophe = Ctrl+Right

; ===== Selection by word and home/end - RIGHT TOP =====
*u::Send "{Home}"          ; u = Home
*o::Send "{End}"           ; o = End
*y::Send "+{Home}"         ; y = Shift+Home
*p::Send "+{End}"          ; p = Shift+End

; ===== Selection by char/word - RIGHT BOTTOM =====
*n::Send "+^{Left}"        ; n = Shift+Ctrl+Left
*m::Send "+{Left}"         ; m = Shift+Left
*.::Send "+{Right}"        ; dot = Shift+Right
*/::Send "+^{Right}"       ; / = Shift+Ctrl+Right

; ===== Selection home/end =====
*z::Send "+{Home}"         ; z = Shift+Home
*x::Send "+{End}"          ; x = Shift+End

; ===== Selection down/up =====
*r::Send "+{Up}"           ; r = Shift+Up
*f::Send "+{Down}"         ; f = Shift+Down
*t::Send "+{PgUp}"         ; t = Shift+PageUp
*g::Send "+{PgDn}"         ; g = Shift+PageDown

; ===== Function keys F1..F12 =====
*1::NavLib.SendFunctionKey(1)
*2::NavLib.SendFunctionKey(2)
*3::NavLib.SendFunctionKey(3)
*4::NavLib.SendFunctionKey(4)
*5::NavLib.SendFunctionKey(5)
*6::NavLib.SendFunctionKey(6)
*7::NavLib.SendFunctionKey(7)
*8::NavLib.SendFunctionKey(8)
*9::NavLib.SendFunctionKey(9)
*0::NavLib.SendFunctionKey(10)
*-::NavLib.SendFunctionKey(11)
*=::NavLib.SendFunctionKey(12)

; --- Block all other letter keys ---
;$b::Return
;$c::Return
;$e::Return
;$f::Return
;$g::Return
; h is Home
; i is Up
; j is Left
; k is Down
; l is Right
;$;::Return
; m is Ctrl+Down
;$n::Return
; $o::Return     ; (removed to allow keyd o = C-right)
; p is PgUp
;$q::Return
;$r::Return
; s is Down
;$t::Return
; u is Ctrl+Up
;$v::Return
; w is Up
;$x::Return  
;$y::Return
;$z::Return

; --- Block remaining symbols ---
; ' is End
;$[::Return
;$]::Return
;$\::Return
$`::Return
; , is Ctrl+Left
; . is Ctrl+Right
; / is PgDn
; ; is End

; --- Block other common keys ---
; $Space::Return
; $Tab::Return
; $Enter::Return
; $BackSpace::Return
; $Delete::Return
; $Escape::Return

; --- Block all other printable characters ---
$!::Return
$@::Return
$#::Return
$$::Return
$%::Return
$^::Return
$&::Return
$*::Return
$(::Return
$)::Return
$_::Return
$+::Return

#HotIf

; Win+CapsLock toggles physical CapsLock state
#CapsLock::
{
    KeybLib.ToggleCapsLock()
}

; Quick delete / backspace outside NavMode
CapsLock & Backspace::
{
    Send "{Delete}"
}
CapsLock & q::
{
    Send "{Delete}"
}
CapsLock & Tab::
{
    Send "{Backspace}"
}
