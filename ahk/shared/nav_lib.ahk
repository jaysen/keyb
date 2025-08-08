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

    ; --- Multi-line Movement ---
    ; Moves the cursor up by specified number of lines
    static MoveUpLines(lineCount := 1) {
        Loop lineCount {
            this.sendKey("Up")
        }
    }

    ; Moves the cursor down by specified number of lines
    static MoveDownLines(lineCount := 1) {
        Loop lineCount {
            this.sendKey("Down")
        }
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
        this.sendKey("Right", "ctrl")
    }
    
    static MoveWordBackward() {
        this.sendKey("Left", "ctrl")
    }
    
    ; --- Advanced Navigation ---
    static MoveToDocStart() {
        this.sendKey("Home", "ctrl")
    }
    
    static MoveToDocEnd() {
        this.sendKey("End", "ctrl")
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
        this.sendKey(direction, "ctrl")
    }
}