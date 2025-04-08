#Requires AutoHotkey v2.0+
; --- Text Manipulation Library ---
; Word/line/block operations with clipboard safety

class TextLib {
    ; --- Internal clipboard cache ---
    static _oldClipboard := ""

    ; --- Clipboard Management ---
    ; Saves the current clipboard to internal storage and clears it
    static SaveClipboard() {
        this._oldClipboard := ClipboardAll()
        A_Clipboard := ""
    }

    ; Restores the clipboard to what it was before the last SaveClipboard
    static RestoreClipboard() {
        A_Clipboard := this._oldClipboard
        this._oldClipboard := ""
    }

    ; Helper to send keys with proper modifier handling
    static sendKeyWithModifiers(key, additionalModifiers := "") {
        cmd := ""
        if GetKeyState("Shift", "P")
            cmd .= "+"
        if GetKeyState("Ctrl", "P")
            cmd .= "^"
        if GetKeyState("Alt", "P")
            cmd .= "!"
        
        ; Add any additional specified modifiers
        if InStr(additionalModifiers, "shift")
            cmd .= "+"
        if InStr(additionalModifiers, "ctrl")
            cmd .= "^" 
        if InStr(additionalModifiers, "alt")
            cmd .= "!"
        
        Send cmd "{" key "}"
    }

    ; --- Character Selection Expansion ---
    ; Expands the current selection one character backward
    static ExpandSelectionByCharBack() {
        this.sendKeyWithModifiers("Left", "shift")
    }

    ; Expands the current selection one character forward
    static ExpandSelectionByCharForward() {
        this.sendKeyWithModifiers("Right", "shift")
    }

    ; --- Word Selection Expansion ---
    ; Expands the current selection one word backward
    static ExpandSelectionByWordBack() {
        Send "+^{Left}"  ; Direct use of Send to maintain compatibility
    }

    ; Expands the current selection one word forward
    static ExpandSelectionByWordForward() {
        Send "+^{Right}"  ; Direct use of Send to maintain compatibility
    }

    ; --- Line-boundary Selection Expansion ---
    ; Expands the current selection to the start of the current line
    static ExpandSelectionToLineStart() {
        this.sendKeyWithModifiers("Home", "shift")
    }

    ; Expands the current selection to the end of the current line
    static ExpandSelectionToLineEnd() {
        this.sendKeyWithModifiers("End", "shift")
    }

    ; --- Line-based Selection Expansion ---
    ; Expands the current selection by specified number of lines upward
    static ExpandSelectionUp(lineCount := 1) {
        Loop lineCount {
            this.sendKeyWithModifiers("Up", "shift")
        }
    }

    ; Expands the current selection by specified number of lines downward
    static ExpandSelectionDown(lineCount := 1) {
        Loop lineCount {
            this.sendKeyWithModifiers("Down", "shift")
        }
    }    

    ; --- Word Selection ---
    ; Selects the current word by moving to its start and expanding to end
    static SelectCurrentWord() {
        ; Move to start of word and then extend selection to end of word
        Send "^{Left}+^{Right}"
    }

    ; --- Line Selection ---
    ; Selects from the start to the end of the current line
    static SelectLine() {
        Send "{Home}+{End}"
    }

    ; ==== Text Deletion/Transformation Functions ====

    ; --- Word Deletion ---
    ; Deletes one word forward (default) or backward, preserving the clipboard
    static DeleteWord(forward := true) {
        this.SaveClipboard()
        if forward
            Send "^+{Right}^x"
        else
            Send "^+{Left}^x"
        this.RestoreClipboard()
    }
    
    ; --- Change to End of Line ---
    ; Deletes everything from cursor to end of line, clipboard-safe
    static ChangeToLineEnd() {
        this.SaveClipboard()
        Send "+{End}^x"
        this.RestoreClipboard()
    }

    ; --- Uppercase Selection ---
    ; Uppercases the currently selected text, preserving the clipboard
    static UppercaseSelection() {
        this.SaveClipboard()
        Send "^c"
        A_Clipboard := Format("{:U}", A_Clipboard)
        Send "^v"
        this.RestoreClipboard()
    }
}