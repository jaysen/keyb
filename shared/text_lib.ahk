#Requires AutoHotkey v2.0+
; --- Text Manipulation Library ---
; Word/line/block operations with clipboard safety

#Include .\nav_lib.ahk

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

    ; --- Character Selection Expansion ---
    ; Expands the current selection one character backward
    static ExpandSelectionByCharBack() {
        Send "+{Left}"
    }

    ; Expands the current selection one character forward
    static ExpandSelectionByCharForward() {
        Send "+{Right}"
    }

    ; --- Word Selection Expansion ---
    ; Expands the current selection one word backward
    static ExpandSelectionByWordBack() {
        Send "+^{Left}"
    }

    ; Expands the current selection one word forward
    static ExpandSelectionByWordForward() {
        Send "+^{Right}"
    }

    ; --- Line-boundary Selection Expansion ---
    ; Expands the current selection to the start of the current line
    static ExpandSelectionToLineStart() {
        Send "+{Home}"
    }

    ; Expands the current selection to the end of the current line
    static ExpandSelectionToLineEnd() {
        Send "+{End}"
    }

    ; --- Line-based Selection Expansion ---
    ; Expands the current selection by specified number of lines upward
    static ExpandSelectionUp(lineCount := 1) {
        Loop lineCount {
            Send "+{Up}"
        }
    }

    ; Expands the current selection by specified number of lines downward
    static ExpandSelectionDown(lineCount := 1) {
        Loop lineCount {
            Send "+{Down}"
        }
    }    


    ; --- Word Selection ---
    ; Selects the current word by moving to its start and expanding to end
    static SelectCurrentWord() {
        Send "^{Left}+^{Right}"
    }

    ; --- Line Selection ---
    ; Selects from the start to the end of the current line
    static SelectLine() {
        NavLib.MoveToLineStart()
        Send "+{End}"
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
