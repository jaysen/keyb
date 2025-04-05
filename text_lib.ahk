#Requires AutoHotkey v2.0+
; --- Text Manipulation Library ---
; Word/line/block operations with clipboard safety

#Include %A_ScriptDir%\nav_lib.ahk

class TextLib {
    ; --- Internal clipboard cache ---
    static _oldClipboard := ""

    ; --- Clipboard Management ---
    static SaveClipboard() {
        this._oldClipboard := ClipboardAll()
        A_Clipboard := ""
    }

    static RestoreClipboard() {
        A_Clipboard := this._oldClipboard
        this._oldClipboard := ""
    }

    ; --- Word Deletion ---
    static DeleteWord(forward := true) {
        this.SaveClipboard()
        if forward
            Send "^+{Right}^x"
        else
            Send "^+{Left}^x"
        this.RestoreClipboard()
    }

    ; --- Word Selection ---
    static SelectCurrentWord() {
        Send "^{Left}+^{Right}"
    }

    ; --- Line Selection ---
    static SelectLine() {
        NavLib.MoveToLineStart()
        Send "+{End}"
    }

    ; --- Change to End of Line ---
    static ChangeToLineEnd() {
        this.SaveClipboard()
        Send "+{End}^x"
        this.RestoreClipboard()
    }

    ; --- Uppercase Selection ---
    static UppercaseSelection() {
        this.SaveClipboard()
        Send "^c"
        A_Clipboard := Format("{:U}", A_Clipboard)
        Send "^v"
        this.RestoreClipboard()
    }
}
