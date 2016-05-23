; #FUNCTION# ====================================================================================================================
; Name ..........: Switch Account
; Description ...: Switch To 1st And 2nd Account
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......: Lakereng (2016) And Extreme DE Side MOD
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchAccount($bAccount)
	$iConfirm = 0
	$AccImg = @ScriptDir & "\images\Multyfarming\Acc" & $bAccount & ".bmp"
	If Not FileExists($AccImg) Then
		SetLog("Acc" & $bAccount & ".bmp Not Found ", $COLOR_RED)
		Return False
	EndIf
	checkMainScreen()
	Send("{CapsLock off}")
	Click(830, 590) ;Click Switch
	If _Sleep(1000) Then Return

	SelectAccount($bAccount)
	If $RunState = False Then Return

	If $iConfirm = 1 Then
		FileDelete((@ScriptDir & "\images\Multyfarming\" & $bAccount & ".bmp"))
	EndIf
	$fullArmy = False
	Local $iLoopCount = 0
	While 1
		Local $Message = _PixelSearch(487, 387, 492, 391, Hex(0xE8E8E0, 6), 0);load pixel
		If IsArray($Message) Then
			SetLog("Load " & $bAccount & " Account", $COLOR_blue)
			Click(512, 433) ;Click Load Button
			If _Sleep(1000) Then Return

			Local $Message = _PixelSearch(470, 249 + $midOffsetY, 478, 255 + $midOffsetY, Hex(0xE8E8E0, 6), 0)
			If IsArray($Message) Then
				$iConfirm = 1
				Click(521, 198) ;Click Confirm
				If _Sleep(1500) Then Return
				Click(339, 215) ;Click Confirm txtbox
				SetLog("Insert CONFIRM To Text Box ", $COLOR_blue)
				If _Sleep(1500) Then Return
				ControlSend($Title, "", "", "{LSHIFT DOWN}{C DOWN}{C UP}{O DOWN}{O UP}{N DOWN}{N UP}{F DOWN}{F UP}{I DOWN}{I UP}{R DOWN}{R UP}{M DOWN}{M UP}{LSHIFT UP}") ;Enter  Confirm  txt
				If _Sleep(2000) Then Return
				Click(521, 198) ;Click Confirm
			Else
				Click(521, 198) ;Click Confirm
			EndIf
			ExitLoop
		EndIf

		$iLoopCount += 1
		ConsoleWrite($iLoopCount & @CRLF)
		If $iLoopCount > 1000 Then
			ExitLoop
		EndIf
	WEnd
EndFunc

Func SelectAccount($bAccount)
	Local $iLoopCount = 0
	Click(437, 399 + $midOffsetY) ;Click  Disconn
	If _Sleep(1000) Then Return
	Click(437, 399 + $midOffsetY) ;Click  Connect
	$iSwCount += 1
	If $iSwCount > 5 Then
		SetLog(" Exit Now ...Cancel change account")
		SetLog("PLease make sure image create From png", $COLOR_RED)
		Click(437, 399 + $midOffsetY) ;Click  Disconn
		ClickP($aAway, 2, 250, "#0291")
		Return
	ElseIf IsMainPage() Then
		Setlog("Change account cancel")
		Return True
	EndIf
		If _Sleep(5000) Then Return
	While 1
		Local $Message = _PixelSearch(164, 45 + $midOffsetY, 166, 281 + $midOffsetY, Hex(0x689F38, 6), 0)
		Local $Message1 = _PixelSearch(164, 45 + $midOffsetY, 166, 281 + $midOffsetY, Hex(0xF5F5F5, 6), 0)
		If IsArray($Message) Then
			CheckAccount($bAccount)
			CheckOK()
			ExitLoop
		ElseIf IsArray($Message1) Then
			CheckAccount($bAccount)
			ExitLoop
		EndIf
		If _Sleep(1200) Then Return

		$iLoopCount += 1
		ConsoleWrite($iLoopCount & @CRLF)
		If $iLoopCount > 1500 Then
			SelectAccount($bAccount)
			ExitLoop
		EndIf
	WEnd

	If $AccountLoc = 1 Then
		LoadAccount ($bAccount)
	EndIf

EndFunc

Func LoadAccount($bAccount)
	Local $iLoopCount = 0

	While 1
		Local $Message = _PixelSearch(487, 387, 492, 391, Hex(0xE8E8E0, 6), 0);load pixel
		If IsArray($Message) Then
			SetLog("Load Main account", $COLOR_blue)
			Click(512, 433) ;Click Load Button
			If _Sleep(1000) Then Return

			Local $Message = _PixelSearch(470, 249 + $midOffsetY, 478, 255 + $midOffsetY, Hex(0xE8E8E0, 6), 0)
			If IsArray($Message) Then
				$iConfirm = 1
				Click(521, 198) ;Click Confirm
				If _Sleep(1500) Then Return
				Click(339, 215) ;Click Confirm txtbox
				SetLog("Insert CONFIRM To Text Box ", $COLOR_blue)
				If _Sleep(1500) Then Return
				ControlSend($Title, "", "", "{LSHIFT DOWN}{C DOWN}{C UP}{O DOWN}{O UP}{N DOWN}{N UP}{F DOWN}{F UP}{I DOWN}{I UP}{R DOWN}{R UP}{M DOWN}{M UP}{LSHIFT UP}") ;Enter  Confirm  txt
				If _Sleep(2000) Then Return
				Click(521, 198) ;Click Confirm
			Else
				Click(521, 198) ;Click Confirm
			EndIf
			ExitLoop
		EndIf

		$iLoopCount += 1
		ConsoleWrite($iLoopCount & @CRLF)
		If $iLoopCount > 1500 Then
			SelectAccount($bAccount)
			ExitLoop
		EndIf
	WEnd
EndFunc

Func CheckOK()

	Local $OkX, $OkY
	$Ok = @ScriptDir & "\images\Multyfarming\Ok.bmp"
	If Not FileExists($Ok) Then Return False
	$OkLoc = 0
	_CaptureRegion()
	If _Sleep(500) Then Return
	For $OkTol = 0 To 20
		If $OkLoc = 0 Then
			$OkX = 0
			$OkY = 0
			$OkLoc = _ImageSearch($Ok, 1, $OkX, $OkY, $OkTol)
			If $OkLoc = 1 Then
				SetLog("Found Ok Button ", $COLOR_GREEN)
				If $DebugSetLog = 1 Then SetLog("Ok Button found (" & $OkX & "," & $OkY & ") tolerance:" & $OkTol, $COLOR_PURPLE)
				Click($OkX, $OkY,1,0,"#0120")
				If _Sleep(500) Then Return
				Return True
			EndIf
		EndIf
	Next
	If $DebugSetLog = 1 Then SetLog("Cannot find OK Button", $COLOR_PURPLE)
	If _Sleep(500) Then Return
EndFunc   ;==>CheckOK Button

Func CheckAccount($bAccount)

	Local $AccountX, $AccountY
	$AccImg = @ScriptDir & "\images\Multyfarming\Acc" & $bAccount & ".bmp"
	If Not FileExists($AccImg) Then
		SetLog("Acc" & $bAccount & ".bmp Not Found ", $COLOR_RED)
		Return False
	EndIf
	$AccountLoc = 0
	_CaptureRegion()
	If _Sleep(500) Then Return
	For $AccountTol = 0 To 20
		If $AccountLoc = 0 Then
			$AccountX = 0
			$AccountY = 0
			$AccountLoc = _ImageSearch($AccImg, 1, $AccountX, $AccountY, $AccountTol)
			If $AccountLoc = 1 Then
				SetLog("Found " & $bAccount & " Account", $COLOR_GREEN)
				If $DebugSetLog = 1 Then SetLog("Found " & $bAccount & " Account (" & $AccountX & "," & $AccountY & ") tolerance:" & $AccountTol, $COLOR_PURPLE)
				Click($AccountX, $AccountY,1,0,"#0120")
				If _Sleep(500) Then Return
				Return True
			EndIf
		EndIf
	Next
	If $DebugSetLog = 1 Then SetLog("Cannot Found " & $bAccount & " Account", $COLOR_PURPLE)
	If _Sleep(500) Then Return
EndFunc