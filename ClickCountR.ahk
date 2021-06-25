; -----------------------------------------------
; ClickCountR by Tim Walsh - twitch.tv/walsh404 
; -----------------------------------------------
SetWorkingDir %A_ScriptDir%
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
Menu, tray, Add, Toogle Mover, ToggleMovable
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

Gosub,LoadData 
Sleep, 100
Gosub, CreateGUI
Sleep, 100
Gosub, UpdateGUI
return

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
    Gui, GUI_Overlay:New, -Caption +LastFound +AlwaysOnTop +ToolWindow, ClickCountR
    Gui, Margin, 0, 0
    Gui, Font, s%textsize% q4 w700, Fontin
    Gui, Add, Picture, BackgroundTrans w99 h-1 x0 y0, %A_ScriptDir%\graymouse.png
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y32 Left vLMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y32 Right vRMB cFFFFFF, 0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x11 y17 Left vLMB_L cFFFFFF, L
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x23 y17 Right vRMB_L cFFFFFF, R
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y45 Center vMMB cFFFFFF, M`n0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x18 y107 Center vSwap cFFFFFF, Swap`n0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x-11 y80 Center vFlask cFFFFFF, Flask`n0
    Gui, Add, Text, BackgroundTrans w%textboxW% h%textboxH% x47 y80 Center vSkill cFFFFFF, Skill`n0
    Gui, Color, %BGColor%
    WinSet, TransColor, FF00FF
    Gui, +Parent%PoEWindowHwnd%
	if (movable = 1)
	    Gui, Add, Picture, BackgroundTrans x33 y70 w32 h32 cFFFFFF gGUI_Drag, %A_ScriptDir%\mover.png
    Gui, Show, X%guiXPos% Y%guiYPos%
;    Gui, +Parent%1%
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
    dataOut := leftClick . "," . rightClick . "," . middleClick . "," . flaskCount . "," . weaponSwap . "," . skillCount . "," . guiXPos . "," . guiYPos . "," . loadedProdPath
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
    guiYPos := inData[8] + 0
    filePathText := inData[9]
    if (guiXPos = "") { ; we must have a default x/ypos if one isn't loaded
        guiXPos := 0
        guiYPos := 0
    } 
    
    if (filePathText = "") ; if the user hasn't already had production_config located 
    {
        ; Path should be - %USERPROFILE%\Documents\My Games\Path of Exile\
        strProdConfigFileName = production_Config.ini
        profile = %USERPROFILE%
        filePathText := % profile . "\Documents\My Games\Path of Exile\" . strProdConfigFileName
    }
    FileRead, prodConfigData, % filePathText
    loadedProdPath := filePathText
    ;check if file loaded, if not ask user to locate
    if ErrorLevel
    {
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


enableGuiDrag(GuiLabel=1) {
	WinGetPos,,,A_w,A_h,A
	return
	
	GUI_Drag:
	    SendMessage 0xA1,2
        WinGetPos,winx,winy,winw,winh
        guiXPos :=  % winx
        guiYPos :=  % winy
        Gosub, ToggleMovable
	return
}

; Menu Bindings
ToggleMovable:
    movable :=  Mod(movable + 1, 2)
    Gui, Destroy
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