#Requires AutoHotkey v2.0
#SingleInstance Force

ascii_gui := Gui("+AlwaysOnTop", "Six-Slot ASCII Generator")
ascii_gui.SetFont("s10 cWhite", "Segoe UI")
ascii_gui.BackColor := "101010"

; --- Inputs ---
ascii_gui.AddText("x10 y10", "Phrase:")
input_Box := ascii_gui.AddEdit("Background404040 x10 y30 w200 vInputWord")

ascii_gui.AddText("x230 y10", "Offset:")
offset_Input := ascii_gui.AddEdit("Background404040 x230 y30 w60 vSecretOffset")

ascii_gui.AddText("x10 y65", "Date Based Salt:")
date_Input := ascii_gui.AddDateTime("x10 y85 w200 vDate", "ddMMyyyy")

reverse_Checkbox := ascii_gui.AddCheckbox("x230 y65 vReverseResult", "Reverse")

; --- Output ---
ascii_gui.AddText("x10 y120", "6-Digit Code:")
output_Box := ascii_gui.AddEdit("Background404040 x10 y140 w200 ReadOnly vOutputHash")

; --- Event Handling ---
input_Box.OnEvent("Change", UpdateHashedCode)
offset_Input.OnEvent("Change", UpdateHashedCode)
reverse_Checkbox.OnEvent("Click", UpdateHashedCode)
date_Input.OnEvent("Change", UpdateHashedCode)

SetDarkWindowFrame(ascii_gui)

ascii_gui.Show("w310 h185")

SetDarkWindowFrame(hwnd, boolEnable := 1) {
    hwnd := WinExist(hwnd)
    if VerCompare(A_OSVersion, "10.0.17763") >= 0
        attr := 19
    if VerCompare(A_OSVersion, "10.0.18985") >= 0
        attr := 20
    DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", attr, "int*", boolEnable, "int", 4)
}

UpdateHashedCode(Control, *) {
    MyGui := Control.Gui
    
    secretPhrase := MyGui["InputWord"].Text
    dateString := MyGui["Date"].Value
    text_to_hash := secretPhrase . SubStr(dateString, 7, 2) . SubStr(dateString, 5, 2) . SubStr(dateString, 1, 4)

    isReversed := MyGui["ReverseResult"].Value
    
    offset := 0
    try offset := Integer(MyGui["SecretOffset"].Text)

    slots := [0, 0, 0, 0, 0, 0]
    Loop Parse text_to_hash
    {
        asciiValue := Ord(A_LoopField)
        asciiString := String(asciiValue)
        digitSum := 0
        Loop Parse asciiString
        {
            digitSum += Integer(A_LoopField)
        }
        charValue := Mod(digitSum, 10)
        slotIndex := Mod(A_Index - 1, 6) + 1
        slots[slotIndex] += charValue
    }

    baseHash := ""
    Loop 6
    {
        baseHash .= Mod(slots[A_Index], 10)
    }

    offsetHash := ""
    Loop Parse baseHash
    {
        offsetHash .= Mod(Integer(A_LoopField) + offset, 10)
    }

    finalResult := isReversed ? StrReverse(offsetHash) : offsetHash
    
    MyGui["OutputHash"].Text := finalResult
}

; --- StrReverse helper function ---
StrReverse(str) {
    reversed := ""
    Loop Parse str
        reversed := A_LoopField . reversed
    return reversed
}