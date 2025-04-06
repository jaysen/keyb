#Requires AutoHotkey v2.0+
; --- Navigation Library ---
; Shared navigation functions for keyboard enhancement scripts

class NavLib {
    ; --- Core Navigation Helper ---
    static sendKey(key, modifiers := "") {
        cmd := ""
        if InStr(modifiers, "shift") or GetKeyState("Shift", "P")
            cmd .= "+"
        if InStr(modifiers, "ctrl") or GetKeyState("Ctrl", "P")
            cmd .= "^"
        if InStr(modifiers, "alt") or GetKeyState("Alt", "P")
            cmd .= "!"
        
        Send cmd "{" key "}"
    }
    
    ; --- Basic Navigation ---
    static MoveUp() {
        this.sendKey("Up")
    }
    
    static MoveDown() {
        this.sendKey("Down")
    }
    
    static MoveLeft() {
        this.sendKey("Left")
    }
    
    static MoveRight() {
        this.sendKey("Right")
    }
    
    ; --- Line Navigation ---
    static MoveToLineStart() {
        this.sendKey("Home")
    }
    
    static MoveToLineEnd() {
        this.sendKey("End")
    }
    
    ; --- Document Navigation ---
    static PageUp() {
        this.sendKey("PgUp")
    }
    
    static PageDown() {
        this.sendKey("PgDn")
    }
    
    ; --- Word Navigation ---
    static MoveWordForward() {
        if GetKeyState("Shift", "P")
            Send "+^{Right}"
        else
            Send "^{Right}"
    }
    
    static MoveWordBackward() {
        if GetKeyState("Shift", "P")
            Send "+^{Left}"
        else
            Send "^{Left}"
    }
    
    ; --- Advanced Navigation ---
    static MoveToDocStart() {
        if GetKeyState("Shift", "P")
            Send "+^{Home}"
        else
            Send "^{Home}"
    }
    
    static MoveToDocEnd() {
        if GetKeyState("Shift", "P")
            Send "+^{End}"
        else
            Send "^{End}"
    }
    

    ; --- Multi-line Movement ---
    ; Moves the cursor up by specified number of lines
    static MoveUpLines(lineCount := 1) {
        Loop lineCount {
            Send "{Up}"
        }
    }

    ; Moves the cursor down by specified number of lines
    static MoveDownLines(lineCount := 1) {
        Loop lineCount {
            Send "{Down}"
        }
    }

    ; --- Function Key Navigation ---
    static SendFunctionKey(number) {
        this.sendKey("F" number)
    }
    
    ; --- Legacy Support ---
    static sendNavKey(key) {
        this.sendKey(key)
    }
    
    static sendCtrlNav(direction) {
        if GetKeyState("Shift", "P")
            Send "^+{" direction "}"
        else
            Send "^{" direction "}"
    }
}