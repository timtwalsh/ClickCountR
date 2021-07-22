; -----------------------------------------------
; ClickCountR by Tim Walsh - twitch.tv/walsh404 
; -----------------------------------------------
SetWorkingDir %A_ScriptDir%
#SingleInstance force
SetBatchLines, -1
ListLines, Off
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
Menu, tray, Add, Original GUI, OriginalMode
Menu, tray, Add, Horizontal GUI, HorizontalMode
Menu, tray, Add, Vertical GUI, VerticalMode
Menu, tray, Add, POE GUI, IntegratedMode
Menu, Tray, Add
Menu, tray, Add, Toogle Mover, ToggleMovable
Menu, tray, Add, Reset Position, ResetPosition
Menu, Tray, Add
Menu, Tray, Add, Reload, ReloadScript
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
Global movable := 0
Global guiMode = 0

Gosub,LoadData 
Sleep, 10
Gosub, CreateGUI
Sleep, 10
Gosub, UpdateGUI
return

; Creates and shows the GUI
CreateGUI:
    if (guiMode = "1") {
        Gosub, HorizontalGUI
    } else if (guiMode = "2") {
        Gosub, VerticalGUI
    } else if (guiMode = "3") {
        Gosub, IntegratedGUI
    } else { 
;        Gosub, IntegratedGUI
        Gosub, SquareGUI
    }
    SetTimer, Timeout, 1000
return

SquareGUI:
    textsize := 9
    textboxH := 80
    textboxW := 64
	BGColor = FF00FF
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow, ClickCountR
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    while (PoEWindowHwnd <= 0)
	    WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	    sleep, 1000
    Gui, +Parent%PoEWindowHwnd%
    Gui, Margin, 0, 0
    Gui, Font, s%textsize% q4 w700, Fontin
    Gui, Add, Picture, BackgroundTrans w99 h-1 x0 y0, %A_ScriptDir%\graymouse.png
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y17 Left vLMB_L cFFFFFF, LMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y32 Left vLMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y17 Right vRMB_L cFFFFFF, RMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y32 Right vRMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y45 Center vMMB_L cFFFFFF, MMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y60 Center vMMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y107 Center vSwap_L cFFFFFF, Swap
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y122 Center vSwap cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x-11 y80 Center vFlask_L cFFFFFF, Flask
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x-11 y95 Center vFlask cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x47 y80 Center vSkill_L cFFFFFF, Skill
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x47 y95 Center vSkill cFFFFFF, 0
    Gui, Color, %BGColor%
    WinSet, TransColor, FF00FF
	if (movable = 1) {
	    Gui, Add, Picture, BackgroundTrans x33 y70 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
    }
    Gui, Show, X%guiXPos% Y%guiYPos%
return

HorizontalGUI:
    textsize := 9
    textboxH := 28
    textboxW := 56
	BGColor = FF00FF
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow, ClickCountR
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    while (PoEWindowHwnd <= 0)
	    WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	    sleep, 1000
    Gui, +Parent%PoEWindowHwnd%
    Gui, Margin, 0, 0
    Gui, Font, s%textsize% q4 w700, Fontin
    Gui, Add, Picture, BackgroundTrans x5 y2, %A_ScriptDir%\horizontal.png
    Gui, Color, %BGColor%
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x2 y3  Center vLMB_L cFFFFFF, LMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x2 y16 Center vLMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x+3 y3 Center vRMB_L cFFFFFF, RMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% xp y16 Center vRMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x+0 y3 Center vMMB_L cFFFFFF, MMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% xp y16 Center vMMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x+0 y3 Center vSwap_L cFFFFFF, Swap
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% xp y16 Center vSwap cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x+0 y3 Center vFlask_L cFFFFFF, Flask
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% xp y16 Center vFlask cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x+0 y3 Center vSkill_L cFFFFFF, Skill
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% xp y16 Center vSkill cFFFFFF, 0
    WinSet, TransColor, FF00FF
	if (movable = 1) {
	    Gui, Add, Picture, BackgroundTrans x5 y0 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
	    Gui, Add, Picture, BackgroundTrans x332 y0 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
    }
    Gui, Show, X%guiXPos% Y%guiYPos%
return

VerticalGUI:
    textsize := 9
    textboxH := 28
    textboxW := 64
	BGColor = FF00FF
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow, ClickCountR
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    while (PoEWindowHwnd <= 0)
	    WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	    sleep, 1000
    Gui, +Parent%PoEWindowHwnd%
    Gui, Margin, 0, 0
    Gui, Font, s%textsize% q4 w700, Fontin
    Gui, Add, Picture, BackgroundTrans x10 y0, %A_ScriptDir%\vertical.png
    Gui, Color, %BGColor%
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 y5  Center vLMB_L cFFFFFF, LMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 yp+14 Center vLMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 y+0 Center vRMB_L cFFFFFF, RMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 yp+14 Center vRMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 y+0 Center vMMB_L cFFFFFF, MMB
    Gui, Add, Text, BackgroundTrans w64 h%textboxH% x0 yp+14 Center vMMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 y+0 Center vSwap_L cFFFFFF, Swap
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 yp+14 Center vSwap cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 y+0 Center vFlask_L cFFFFFF, Flask
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 yp+14 Center vFlask cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 y+0 Center vSkill_L cFFFFFF, Skill
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x0 yp+14 Center vSkill cFFFFFF, 0
    WinSet, TransColor, FF00FF
	if (movable = 1) {
	    Gui, Add, Picture, BackgroundTrans x15 y3 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
	    Gui, Add, Picture, BackgroundTrans x15 y215 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
    }
    Gui, Show, X%guiXPos% Y%guiYPos%
return

IntegratedGUI:
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    WinGetPos, winX, winY, winW, winH, ahk_id %PoEWindowHwnd%
    textsize := 9
    textboxH := 28
    textboxW := 64
    LMBLx := winW-404
    LMBLy := winH-162
    LMBx := winW-404
    LMBy := winH-143
    RMBLx := winW-295
    RMBLy := winH-162
    RMBx := winW-295
    RMBy := winH-143
    MMBLx := winW-348
    MMBLy := winH-162
    MMBx := winW-348
    MMBy := winH-143
    SwapLx := winW-64
    SwapLy := winH-55
    Swapx := winW-64
    Swapy := winH-20
    FlaskLx := winX+304
    FlaskLy := winH-138
    Flaskx := winX+345
    Flasky := winH-138
    SkillLx := winW-494
    SkillLy := winH-122
    Skillx := winW-458
    Skilly := winH-122
	BGColor = FF00FF
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow, ClickCountR
    while (PoEWindowHwnd <= 0)
	    WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	    sleep, 1000
    Gui, +Parent%PoEWindowHwnd%
    Gui, Margin, 0, 0
    Gui, Font, s%textsize% q4 w700, Fontin
;    Gui, Add, Picture, BackgroundTrans x10 y0, %A_ScriptDir%\vertical.png
    Gui, Color, %BGColor%
;    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%LMBLx%   y%LMBLy%     Center vLMB_L   cFFFFFF, LMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%LMBx%    y%LMBy%      Center vLMB     cFFFFFF, 0
;    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%RMBLx%   y%RMBLy%     Center vRMB_L   cFFFFFF, RMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%RMBx%    y%RMBy%      Center vRMB     cFFFFFF, 0
;    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%MMBLx%   y%MMBLy%     Center vMMB_L   cFFFFFF, MMB
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%MMBx%    y%MMBy%      Center vMMB     cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%SwapLx%  y%SwapLy%    Center vSwap_L  cFFFFFF, Weapon Swaps
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%Swapx%   y%Swapy%     Center vSwap    cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%FlaskLx% y%FlaskLy%   Center vFlask_L cFFFFFF, Flasks
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%Flaskx%  y%Flasky%    Center vFlask   cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%SkillLx% y%SkillLy%   Center vSkill_L cFFFFFF, Skills
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x%Skillx%  y%Skilly%    Center vSkill   cFFFFFF, 0
    WinSet, TransColor, FF00FF
	if (movable = 1) {
	    movable := 0
    }
    Gui, Show, X%guiXPos% Y%guiYPos%
return

AwaitPoEHwnd:
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
    
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
	GuiControl, GUI_Overlay:, MMB,%numM%
    numS := NumberText(skillCount)
	GuiControl, GUI_Overlay:, Skill,%numS%
    numF := NumberText(flaskCount)
	GuiControl, GUI_Overlay:, Flask,%numF%
    numW := NumberText(weaponSwap)
	GuiControl, GUI_Overlay:, Swap,%numW%
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
    dataOut := leftClick . "," . rightClick . "," . middleClick . "," . flaskCount . "," . weaponSwap . "," . skillCount . "," . guiXPos . "," . guiYPos . "," . loadedProdPath . "," . guiMode
    file := A_ScriptDir . "\clickData.csv"
    fileOut := FileOpen(file, "rw")
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
    if (inData.length() > 0) { ; load values if file data is read
        leftClick := 0 + inData[1]
        rightClick := 0 + inData[2]
        middleClick := 0 + inData[3]
        flaskCount := 0 + inData[4]
        weaponSwap := 0 + inData[5]
        skillCount := 0 + inData[6]
        guiXPos := 0 + inData[7]
        guiYPos := 0 + inData[8]
        guiMode := 0 + inData[10]
        filePathText := inData[9]
    } else {
        leftClick := 0
        rightClick := 0
        middleClick := 0
        flaskCount := 0
        weaponSwap := 0
        skillCount := 0
        guiXPos := 0
        guiYPos := 0
        guiMode := 0
    }
    if (filePathText = "") { ; if the user hasn't already had production_config located 
        ; Path should be - %USERPROFILE%\Documents\My Games\Path of Exile\
        strProdConfigFileName = production_Config.ini
        profile = %USERPROFILE%
        filePathText := % profile . "\Documents\My Games\Path of Exile\" . strProdConfigFileName
    }
    FileRead, prodConfigData, % filePathText
    loadedProdPath := filePathText
    ;check if file loaded, if not ask user to locate
    if ErrorLevel {
        msgbox, "Can't automatically locate production_Config.ini`nShould be in Documents\My Games\Path of Exile"
        production_Config.ini := profile . "\Documents\My Games\Path of Exile\"
        FileSelectFile, selectedFilePath, 3, production_Config.ini , Locate production_Config.ini, (production_Config.ini)   
        FileRead, prodConfigData, % selectedFilePath 
        loadedProdPath := selectedFilePath
    }
    ; We now have an enviroment path or user selected production_Config.ini read into prodConfigData
    ; loadedProdPath can be saved for future loading (so user doesn't have to manually select each time
    
    ; load all data from POEs production Config ini from 
    globalsFromIni(loadedProdPath,"_") ; ACTION_KEYS_keyname = val
    
    ; simple map of poe mod codes -> ahk mod chars
    modId_to_char := {1:"+",2:"^",3:"!"}
    ; build the map of poe keycodes -> AHK keynames
    keyCode_to_AHK_Ref := {"":""}
    FileRead, keycode_ahk_map, keycode_ahkid_map.csv
    StringSplit, arrKeycodeAhk, keycode_ahk_map, `,
    Loop, % arrKeycodeAhk%0%, ; loops through each of the prod config keys we care about
    {
        StringSplit, item, arrKeycodeAhk%A_Index%, :
        keyCode_to_AHK_Ref[item1] := item2
    }
    
    ; the important/tracked poe key binds
    strProdConfigVarNames := "use_bound_skill1|use_bound_skill2|use_bound_skill3|use_bound_skill4|use_bound_skill5|use_bound_skill6|use_bound_skill7|use_bound_skill8|use_bound_skill9|use_bound_skill10|use_bound_skill11|use_bound_skill12|use_bound_skill13|use_flask_in_slot1|use_flask_in_slot2|use_flask_in_slot3|use_flask_in_slot4|use_flask_in_slot5|weapon_swap"
    Loop, parse, % strProdConfigVarNames, |, ; loops through each of the tracked config keys  
    {
        keyWithMod = []
        varName = % "ACTION_KEYS_" . A_LoopField ; name reference for loopfield
        StringSplit, keyWithMod, %varName%, %A_Space%, `r
        if (keyWithMod%0% == 1) 
        { ; keys without mods
            mod := ""
            key := keyCode_to_AHK_Ref[keyWithMod1]
        } 
        else 
        { ; keys with mods
            ; hotkey := modcode keycode (eg. 50 3 = !2)
            key := keyCode_to_AHK_Ref[keyWithMod1]
            mod := modId_to_char[keyWithMod2]
        }
        Hotkey, % "~" . mod . key . " up", %A_LoopField%, On ; Bind the hotkey to the label with passthrough
        if (A_LoopField = "use_bound_skill1") {
          Hotkey, % "~" . "!" . key . " up", %A_LoopField%, On ; Bind mods for left click
          Hotkey, % "~" . "^" . key . " up", %A_LoopField%, On
          Hotkey, % "~" . "+" . key . " up", %A_LoopField%, On
        }
    }
return

; Creates global variables from an Ini file.
globalsFromIni(_SourcePath, _VarPrefixDelim = "_")
{
    Global
    Local FileContent, CurrentPrefix, CurrentVarName, CurrentVarContent, DelimPos
    FileRead, FileContent, %_SourcePath%
    If ErrorLevel = 0
    {
        Loop, Parse, FileContent, `n, `r%A_Tab%%A_Space%
        {
            If A_LoopField Is Not Space
            {
                If (SubStr(A_LoopField, 1, 1) = "[")
                {
                    StringTrimLeft, CurrentPrefix, A_LoopField, 1
                    StringTrimRight, CurrentPrefix, CurrentPrefix, 1
                }
                Else
                {
                    DelimPos := InStr(A_LoopField, "=")
                    StringLeft, CurrentVarName, A_LoopField, % DelimPos - 1
                    StringTrimLeft, CurrentVarContent, A_LoopField, %DelimPos%
                    CurrentVarName = %CurrentVarName%
                    %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
                }
            }
        }
    }
}


GUI_Drag:
    SendMessage 0xA1,2
    WinGetPos,winx,winy,winw,winh
    guiXPos :=  % winx
    guiYPos :=  % winy
    Gosub, ToggleMovable
return


ResetPosition:
    guiXPos :=  0
    guiYPos :=  0
    Gosub, ToggleMovable
return

; Menu Bindings

OriginalMode:
    guiMode := 0
    Gosub, CreateGUI
    Gosub, UpdateGUI
    Gosub, ToggleMovable
return

HorizontalMode:
    guiMode := 1
    Gosub, CreateGUI
    Gosub, UpdateGUI
    Gosub, ToggleMovable
return

VerticalMode:
    guiMode := 2
    Gosub, CreateGUI
    Gosub, UpdateGUI
    Gosub, ToggleMovable
return

IntegratedMode:
    guiMode := 3
    Gosub, ResetPosition
    Gosub, CreateGUI
    Gosub, UpdateGUI
    Gosub, ToggleMovable
return

ToggleMovable:
    movable :=  Mod(movable + 1, 2)
    Gosub, CreateGUI
    Gosub, UpdateGUI
return

ReloadScript:
    Reload
return

CloseScript:
    ExitApp
return

; Labels/Binding for the Keys
#IfWinActive ahk_class POEWindowClass
; Primary Skills
use_bound_skill1:
    leftClick += 1
	Gosub, UpdateGUI
return

use_bound_skill2:
    middleClick += 1
	Gosub, UpdateGUI
return

use_bound_skill3:
    rightClick += 1
	Gosub, UpdateGUI
return

; Skills
use_bound_skill4:
use_bound_skill5:
use_bound_skill6:
use_bound_skill7:
use_bound_skill8:
use_bound_skill9:
use_bound_skill10:
use_bound_skill11:
use_bound_skill12:
use_bound_skill13:
    skillCount +=1 
    Gosub, UpdateGUI
return

; Flasks
use_flask_in_slot1:
use_flask_in_slot2:
use_flask_in_slot3:
use_flask_in_slot4:
use_flask_in_slot5:
    flaskCount += 1
	Gosub, UpdateGUI
return

weapon_swap:
    weaponSwap +=1 
	Gosub, UpdateGUI
return