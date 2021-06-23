; -----------------------------------------------
; ClickCountR by Tim Walsh - twitch.tv/walsh404 
; -----------------------------------------------
SetWorkingDir %A_ScriptDir%
#NoEnv ; compatibility
#SingleInstance force
SetBatchLines, -1
ListLines, Off
#SingleInstance force
#KeyHistory 0
#ctrls = 19

; Game ID
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64_KG.exe

Menu, Tray, NoStandard
Menu, Tray, Add, Reload, ReloadScript
Menu, tray, Add, Open Settings, LaunchSettings
Menu, Tray, Add, Close, CloseScript
Menu, tray, tip, ClickCountR - by TimWalsh ; Custom traytip

Global guiXPos := 0
Global guiYPos := 0
Global leftClick :=0
Global rightClick := 0
Global middleClick := 0
Global flaskCount := 0
Global weaponSwap := 0
Global skillCount := 0

Gosub, loadData 
if (leftClick > 0) {
    Gosub, LaunchSettings
    Gosub, ButtonSave ; Skip the settings if already configured
} else {
    Gosub, LaunchSettings
}
Gosub, CreateGUI
Sleep, 100
Gosub, UpdateGUI
return

LaunchSettings:
    SplitPath, A_ScriptName, , , , strIniFilename
    strIniFilename := strIniFilename . ".ini"
    strIniPathFilename := A_ScriptDir . "\" . strIniFilename
    strMouseButtons := "|LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|WheelLeft|WheelRight|" ; leave last | to enable default value
    
    ;---------------------------------------
    ; Ini key names, matching hotkey variables names and default values for hotkeys
    strIniKeyNames := "PrimarySkill1|PrimarySkill2|PrimarySkill3|Skill1|Skill2|Skill3|Skill4|Skill5|Skill6|Skill7|Skill8|Skill9|Skill10|Flask1|Flask2|Flask3|Flask4|Flask5|WeaponSwap|"
    StringSplit, arrIniKeyNames, strIniKeyNames, |
    strHotkeyVarNames := "PrimarySkill1|PrimarySkill2|PrimarySkill3|Skill1|Skill2|Skill3|Skill4|Skill5|Skill6|Skill7|Skill8|Skill9|Skill10|Flask1|Flask2|Flask3|Flask4|Flask5|WeaponSwap"
    StringSplit, arrHotkeyVarNames, strHotkeyVarNames, | 
    strHotkeyDefaults := "LButton|MButton|RButton|Q|W|E|R|T|^Q|^W|^E|^R|^T|1|2|3|4|5|X"
    StringSplit, arrHotkeyDefaults, strHotkeyDefaults, |
    
    ;---------------------------------------
    ; Gui hotkey titles and descriptions
    strTitles := "Primary Skill 1|Primary Skill 2|Primary Skill 3|Skill 1|Skill 2|Skill 3|Skill 4|Skill 5|Skill 6|Skill 7|Skill 8|Skill 9|Skill 10|Flask 1|Flask 2|Flask 3|Flask 4|Flask 5|Weapon Swap"
    StringSplit, arrTitles, strTitles, |
    arrDescriptions1 := "(eg. Left Mouse)"
    arrDescriptions2 := "(eg. Middle Mouse)"
    arrDescriptions3 := "(eg. Right Mouse)"
    arrDescriptions4 := "(eg. Q)"
    arrDescriptions5 := "(eg. W)"
    arrDescriptions6 := "(eg. E)"
    arrDescriptions7 := "(eg. R)"
    arrDescriptions8 := "(eg. T)"
    arrDescriptions9 := "(eg. Ctrl+Q)"
    arrDescriptions10 := "(eg. Ctrl+W)"
    arrDescriptions11 := "(eg. Ctrl+E)"
    arrDescriptions12 := "(eg. Ctrl+R)"
    arrDescriptions13 := "(eg. Ctrl+T)"
    arrDescriptions14 := "(eg. 1)"
    arrDescriptions15 := "(eg. 2)"
    arrDescriptions16 := "(eg. 3)"
    arrDescriptions17 := "(eg. 4)"
    arrDescriptions18 := "(eg. 5)"
    arrDescriptions18 := "(eg. X)"
    
    ; Build Gui title
    Gui, Font, s8 w700
    Gui, Add, Text, x5 y10, ClickCountR 
    Gui, Font
    
    ; Build Hotkey gui rows
    loop, % arrIniKeyNames%0%
    {
        IniRead, arrHotkeyVarNames%A_Index%, %strIniPathFilename%, Global, % arrIniKeyNames%A_Index%, % arrHotkeyDefaults%A_Index%
        SplitHotkey(arrHotkeyVarNames%A_Index%, strMouseButtons
            , strModifiers%A_Index%, strKey%A_Index%, strMouseButton%A_Index%, strMouseButtonsWithDefault%A_Index%)
        GuiHotkey(A_Index)
    }
    ; Add footer
    Gui, Add, Text
    Gui, Add, Button,x220 w100 h50 vbtnSave gButtonSave, Save Keybinds
    GuiControl, Focus, btnSave
    Gui, +AlwaysOnTop
    Gui, Show
return
 
; Row Builder
GuiHotkey(intIndex)
{
	global
	; Headings
	if (intIndex == 1) { ; 1 is the first index in AHK (why?)
	    Gui, New,,ClickCountR Options
	    Gui, Font, s8 w700
        Gui, Add, Text, yp x98 w25 center, Shift
        Gui, Add, Text, yp x+11 w25 center, Ctrl
        Gui, Add, Text, yp x+10 w25 center, Alt
        Gui, Add, Text, yp x+10 w100 center, Keyboard
        Gui, Add, Text, yp x+30 w80 center, Mouse
    }
    if (intIndex <= #ctrls) { 
        Gui, Font
        Gui, Add, Text, x5 y+9 w90 right, % arrTitles%intIndex%
        Gui, Add, CheckBox, yp x+10 vblnShift%intIndex%, %A_Space%
        
        GuiControl, , blnShift%intIndex%, % InStr(strModifiers%intIndex%, "+") ? 1 : 0
        Gui, Add, CheckBox, yp x+10 vblnCtrl%intIndex%, %A_Space%
        GuiControl, , blnCtrl%intIndex%, % InStr(strModifiers%intIndex%, "^") ? 1 : 0
        Gui, Add, CheckBox, yp x+10 vblnAlt%intIndex%, %A_Space%
        GuiControl, , blnAlt%intIndex%, % InStr(strModifiers%intIndex%, "!") ? 1 : 0
        Gui, Add, Hotkey, yp x+10 w100 vstrKey%intIndex% gHotkeyChanged
        GuiControl, , strKey%intIndex%, % strKey%intIndex%
        Gui, Add, Text, yp x+5, %A_Space%or
        Gui, Add, DropDownList, yp x+10 w80 vstrMouse%intIndex% gMouseChanged, % strMouseButtonsWithDefault%intIndex%
        Gui, Add, Text, yp x+5 w100, % arrDescriptions%intIndex%
	} else {
        Gui, Add, Text
	    Gui, Font, s8 w700
	    Gui, Add, Text, x5 y+9 w250 center vXLabel, X position
	    Gui, Add, Text, x+20 yp w250 center vYLabel, Y position
	    screenWidth := A_screenWidth-50
	    screenHeight := A_screenHeight-100
	    Gui, Add, Slider, x5 y+9 w250 right ToolTipBottom vXposSlide gSubXpos Range0-%ScreenWidth% , %guiXPos%
	    Gui, Add, Slider, x+20 yp w250 right ToolTipBottom vYposSlide gSubYpos Range0-%ScreenHeight% , %guiYPos%
	}
	return
}

ButtonSave:
    Gui, Submit
    strIniVarNames := "PrimarySkill1|PrimarySkill2|PrimarySkill3|Skill1|Skill2|Skill3|Skill4|Skill5|Skill6|Skill7|Skill8|Skill9|Skill10|Flask1|Flask2|Flask3|Flask4|Flask5|WeaponSwap"
    StringSplit, arrIniVarNames, strIniVarNames, |
    
    Loop, % arrIniVarNames%0%
    {
        strHotkey%A_Index% := Trim(strKey%A_Index% . strMouse%A_Index%)
        if StrLen(strHotkey%A_Index%)
        {
            if (blnWin%A_Index%)
                strHotkey%A_Index% := "#" . strHotkey%A_Index%
            if (blnAlt%A_Index%)
                strHotkey%A_Index% := "!" . strHotkey%A_Index%
            if (blnShift%A_Index%)
                strHotkey%A_Index% := "+" . strHotkey%A_Index%
            if (blnCtrl%A_Index%)
                strHotkey%A_Index% := "^" . strHotkey%A_Index%
            IniWrite, % strHotkey%A_Index%, %strIniPathFilename%, Global, % arrIniVarNames%A_Index%
            Hotkey, % "~" . strHotkey%A_Index% . " up", Label%A_Index%, On ; Bind the hotkey to the label with passthrough
        }
        else
            IniDelete, %strIniPathFilename%, Global, % arrIniVarNames%A_Index%
    }
return

HotkeyChanged:
    strHotkeyControl := A_GuiControl
    strHotkey := %strHotkeyControl%
    
    if !StrLen(strHotkey)
        return
    
    SplitModifiersFromKey(strHotkey, strModifiers, strKey)
    
    if StrLen(strModifiers)
        GuiControl, , %A_GuiControl%, None
    else
    {
        StringReplace, strMouseControl, strHotkeyControl, Key, Mouse
        GuiControl, ChooseString, %strMouseControl%, %A_Space%
    }
return

MouseChanged:
    strMouseControl := A_GuiControl
    StringReplace, strHotkeyControl, strMouseControl, Mouse, Key 
    GuiControl, , %strHotkeyControl%, % ""
return

SplitHotkey(strHotkey, strMouseButtons, ByRef strModifiers, ByRef strKey, ByRef strMouseButton, ByRef strMouseButtonsWithDefault)
{
	SplitModifiersFromKey(strHotkey, strModifiers, strKey)

	if InStr(strMouseButtons . "|", "|" . strKey . "|")
	{
		strMouseButton := strKey
		strKey := ""
		StringReplace, strMouseButtonsWithDefault, strMouseButtons, %strMouseButton%|, %strMouseButton%||
	}
	else
		strMouseButtonsWithDefault := strMouseButtons
}

SplitModifiersFromKey(strHotkey, ByRef strModifiers, ByRef strKey)
{
	intModifiersEnd := GetFirstNotModifier(strHotkey)
	StringLeft, strModifiers, strHotkey, %intModifiersEnd%
	StringMid, strKey, strHotkey, % (intModifiersEnd + 1)
}

GetFirstNotModifier(strHotkey)
{
	intPos := 0
	loop, Parse, strHotkey
		if (A_LoopField = "^") or (A_LoopField = "!") or (A_LoopField = "+") or (A_LoopField = "#")
			intPos := intPos + 1
		else
			return intPos
	return intPos
}

; Position
SubXpos:
    guiXPos :=  % XposSlide
    Gosub, CreateGui
return

SubYpos:
    guiYPos :=  % YposSlide
    Gosub, CreateGui
return

; Creates and shows the GUI
CreateGUI:
    textsize := 9
    textboxH := 80
    textboxW := 64
	BGColor = FF00FF
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow,ClickCountR
    Gui, GUI_Overlay:Margin, 0, 0
    Gui, GUI_Overlay:Font, s%textsize% q4 w700, Fontin
    Gui, GUI_Overlay:Add, Picture, BackgroundTrans w99 h-1 x0 y0, %A_ScriptDir%\graymouse.png
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y32 Left vLMB cFFFFFF, 0
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y32 Right vRMB cFFFFFF, 0
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y17 Left vLMB_L cFFFFFF, L
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y17 Right vRMB_L cFFFFFF, R
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y45 Center vMMB cFFFFFF, M`n0
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y107 Center vSwap cFFFFFF, Swap`n0
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x-11 y80 Center vFlask cFFFFFF, Flask`n0
    Gui, GUI_Overlay:Add, Text, BackgroundTrans w%textboxW% h%textboxH% x47 y80 Center vSkill cFFFFFF, Skill`n0
    Gui, GUI_Overlay:Color, %BGColor%
    WinSet, TransColor, FF00FF
    Gui, GUI_Overlay:+Parent%PoEWindowHwnd%
    Gui, Show, X%guiXPos% Y%guiYPos%
    SetTimer, Timeout, 1000
return

Timeout:
    Gosub, SaveData
return

UpdateGUI:
    numL := NumberText(leftClick)
	GuiControl, GUI_Overlay:, LMB,%numL%
    numR := NumberText(rightClick)
	GuiControl, GUI_Overlay:, RMB,%numR%
    numM := NumberText(middleClick)
	GuiControl, GUI_Overlay:, MMB,M`n%numM%
    numS := NumberText(skillCount)
	GuiControl, GUI_Overlay:, Skill,Skill`n%numS%
    numF := NumberText(flaskCount)
	GuiControl, GUI_Overlay:, Flask,Flask`n%numF%
    numW := NumberText(weaponSwap)
	GuiControl, GUI_Overlay:, Swap,Swap`n%numW%
return

; Make the numbers fit in their respective positons by converting to short text
NumberText(number)
{
    text := ""
    if (number >= 10000000000) { ; billion
        number *= 0.000000001
        text := Format("{1:0.1f}", number) . "b"
    } else if (number >= 1000000) { ; 100 million
             number *= 0.000001
             text := Format("{1:0.0f}", number) . "m"
    } else if (number >= 1000000) { ; million
        number *= 0.000001
        text := Format("{1:0.1f}", number) . "m"
    } else if (number >= 100000) { ; 100 thousand
             number *= 0.001
             text := Format("{1:0.0f}", number) . "k"
    } else if (number >= 1000) { ; thousand
        number *= 0.001
        text := Format("{1:0.1f}", number) . "k"
    } else {
        text := number
    }
    return text
}

SaveData:
    dataOut := leftClick . "," . rightClick . "," . middleClick . "," . flaskCount . "," . weaponSwap . "," . skillCount . "," . guiXPos . "," . guiYPos
    file := A_ScriptDir . "\clickData.csv"
    fileOut := FileOpen(file, "w")
    if !IsObject(fileOut)
    {
        MsgBox Can't open "%FileName%" for writing.
        return
    }
    fileOut.write(dataOut)

return

LoadData:
    FileRead, FILE_CONTENTS, clickData.csv
    inData := StrSplit(FILE_CONTENTS, ",")
    leftClick := inData[1] + 0
    rightClick := inData[2] + 0
    middleClick := inData[3] + 0
    flaskCount := inData[4] + 0
    weaponSwap := inData[5] + 0
    skillCount := inData[6] + 0
    guiXPos := inData[7] + 0
    guiYPos := inData[8] + 0
    if (guiXPos = "") { ; we must have a default x/ypos if one isn't loaded
        guiXPos := 0
        guiYPos := 0
    } 
return

; Menu Bindings
ReloadScript:
    Reload
return

CloseScript:
    ExitApp
return

; Labels/Binding for the Keys
#IfWinActive ahk_class POEWindowClass
; Primary Skills
Label1:
    leftClick += 1
	Gosub, UpdateGUI
return

Label2:
    middleClick += 1
	Gosub, UpdateGUI
return

Label3:
    rightClick += 1
	Gosub, UpdateGUI
return

; Skills
Label4:
Label5:
Label6:
Label7:
Label8:
Label9:
Label10:
Label11:
Label12:
Label13:
    skillCount +=1 
    Gosub, UpdateGUI
return

; Flasks
Label14:
Label15:
Label16:
Label17:
Label18:
    flaskCount += 1
	Gosub, UpdateGUI
return

Label19:
Label20:
    weaponSwap +=1 
	Gosub, UpdateGUI
return
