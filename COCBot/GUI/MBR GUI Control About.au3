; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Collectors
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenGUIAbout()
	If $hAboutGUI = 0 Then
	   GUIAbout()
	   GUISetState(@SW_SHOW, $hAboutGUI)
	   GUISetState(@SW_DISABLE, $frmBot)
	EndIf
EndFunc
Func CloseGUIAbout()
	GUIDelete($hAboutGUI)
	$hAboutGUI = 0
	GUISetState(@SW_ENABLE, $frmBot)
	WinActivate($frmBot)
EndFunc