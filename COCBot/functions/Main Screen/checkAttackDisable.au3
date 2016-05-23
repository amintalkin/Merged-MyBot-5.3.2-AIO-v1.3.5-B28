
; #FUNCTION# ====================================================================================================================
; Name ..........: checkAttackDisable
; Description ...:
; Syntax ........: checkAttackDisable($iSource, [$Result = getAttackDisable(X,Y])
; Parameters ....: $Result              - [optional] previous saved string from OCR read. Default is getAttackDisable(346, 182) or getAttackDisable(180,167)
;					    $iSource				 - integer, 1 = called during search process (preparesearch/villagesearch)
;																	2 = called during time when not trying to attack (all other idle times have different message)
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: TheMaster (2015), MonkeyHunter (2015-12/2016-1,2), Hervidero (2015-12),
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkAttackDisable($iSource, $Result = "")
	Local $i = 0, $iCount = 0
	Local $iModSource

	If $bDisableBreakCheck = True Then Return ; check Disable break flag, added to prevent recursion for CheckBaseQuick

	If $ichkSinglePBTForced And _DateIsValid($sPBStartTime) Then
		Local $iTimeTillPBTstartSec = Int(_DateDiff('s', $sPBStartTime, _NowCalc())) ; time in seconds
		If $debugSetlog = 1 Then Setlog("PB starts in: " & $iTimeTillPBTstartSec & " Seconds", $COLOR_PURPLE)
		If $iTimeTillPBTstartSec >= 0 Then ; test if PBT date/time in past (positive value) or future (negative value
			$iModSource = $iTaBChkTime
		Else
			Return
		EndIf
	Else
		$iModSource = $iSource
	EndIf

	Switch $iModSource
		Case $iTaBChkAttack ; look at location 346, 182 for "disable", "for" or "after" if checked early enough
			While $Result = "" Or (StringLen($Result) < 3)
				$i += 1
				If _Sleep($iDelayAttackDisable100) Then Return
				$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak if not found due slow PC
				If $i >= 3 Then ExitLoop
			WEnd
			If $debugSetlog = 1 Then Setlog("Attack Personal Break OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "disable") <> 0 Or StringInStr($Result, "for") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text strings, 'after' added for Personal Break
					Setlog("Attacking disabled, Personal Break detected...", $COLOR_RED)
					If _CheckPixel($aSurrenderButton, $bCapturePixel) Then ; village search requires end battle 1s, so check for surrender/endbattle button
						ReturnHome(False, False) ;If End battle is available
					Else
						CloseCoC()
					EndIf
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case $iTaBChkIdle ; look at location 180, 167 for the have "been" online too long message, and the "after" Personal Break message
			If $Result = "" Then $Result = getAttackDisable(180, 156 + $midOffsetY) ; change to 180, 186 for 860x780
			If _Sleep($iDelayAttackDisable500) Then Return ; short wait to not delay to much
			If $Result = "" Or (StringLen($Result) < 3) Then $Result = getAttackDisable(180, 156 + $midOffsetY) ; Grab Ocr for "Have Been" 2nd time if not found due slow PC
			If $debugSetlog = 1 Then Setlog("Personal Break OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "been") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text string, 'after' added for Personal Break
					Setlog("Online too long, Personal Break detected....", $COLOR_RED)
					checkMainScreen()
				; IceCube (Misc v1.0)					
				ElseIf StringInStr($Result, "banned") <> 0 Then ; Banned detection
					Setlog("BANNED message detected.\nPlease check your account ASAP.\n\nBOT will enter in full stop mode now!", $COLOR_RED)
					$iForceNotify = 1
					_Push("BANNED message detected.\nPlease check your account ASAP.\n\nBOT will enter in full stop mode now!")
					btnStop()
				; IceCube (Misc v1.0)
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case $iTaBChkTime
			If $iSource = $iTaBChkAttack Then ; If from village search, need to return home
				While _CheckPixel($aIsAttackPage, $bCapturePixel) = False  ; Wait for attack page ready
					If _Sleep($iDelayAttackDisable500) Then Return
					$iCount += 1
					If $debugSetlog = 1 Then setlog("wait end battle button " & $iCount, $COLOR_PURPLE)
					If $iCount > 40 Or isProblemAffect(True) Then ; wait 20 seconds and give up.
						checkObstacles()
						ExitLoop
					EndIf
				WEnd
				If _CheckPixel($aIsAttackPage, $bCapturePixel) Then ReturnHome(False, False) ;If End battle is available
			EndIf
			If $iSource = $iTaBChkIdle Then
				While _CheckPixel($aIsMain, $bCapturePixel) = False
					If _Sleep($iDelayAttackDisable500) Then Return
					ClickP($aAway, 1, 0, "#0000") ;Click Away to close Topen page
					$iCount += 1
					If $debugSetlog = 1 Then setlog("wait main page" & $iCount, $COLOR_PURPLE)
					If $iCount > 5 Or isProblemAffect(True) Then ; wait 2.5 seconds, give up, let checkobstacles try to clear page
						checkObstacles()
						ExitLoop
					EndIf
				WEnd
				If _Sleep($iDelayAttackDisable500) Then Return
			EndIf
			If $aShieldStatus[0] = "guard" Then
				Setlog("Unable to Force PB, Guard shield present", $COLOR_BLUE)
			Else
				Setlog("Forcing Early Personal Break Now!!", $COLOR_GREEN)
			EndIf
		Case Else
			Setlog("Misformed $sSource parameter, silly programmer made a mistake!", $COLOR_PURPLE)
			Return False
	EndSwitch

	Setlog("Prepare base before Personal Break..", $COLOR_BLUE)
	$bDisableBreakCheck = True ; Set flag to stop checking for attackdisable messages, stop recursion
	CheckBaseQuick() ; check and restock base before exit.
	$bDisableBreakCheck = False ; reset break check flag to normal

	$Is_ClientSyncError = False ; reset OOS fast restart flag
	$Is_SearchLimit = False ; reset search limit flag
	$Restart = True ; Set flag to restart the process at the bot main code when it returns

	; IceCube (Multy-Farming Revamp v1.6)	
	If $ichkMultyFarming = 1 Then
		SetLog("Multy-Farming Mode Active...", $COLOR_RED)
		SetLog("Please don't PAUSE/STOP BOT during profile change", $COLOR_RED)
		$canRequestCC = True
		$bDonationEnabled = True
		RequestCC()
		$FirstStart = True
		$RunState = True
		$iSwCount = 0
		If $sCurrProfile = "[01] Main" Then
			If IniRead($sProfilePath & "\[02] Second\config.ini", "MOD", "MultyFarming", "0") = "1" Then
				SwitchAccount("Second")
			ElseIf IniRead($sProfilePath & "\[03] Third\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
				SwitchAccount("Third")
			ElseIf IniRead($sProfilePath & "\[04] Fourth\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
				SwitchAccount("Fourth")
			Else
				SetLog("You don't have other profiles configured for multy-farming. Swithing accounts canceled.", $COLOR_RED)
				PrepareForPersonalBreak($iModSource)
			EndIF
			
		ElseIf $sCurrProfile = "[02] Second" Then
			If $iAccount = "3" Or $iAccount = "4" Then
				If IniRead($sProfilePath & "\[03] Third\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Third")
				ElseIf IniRead($sProfilePath & "\[04] Fourth\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Fourth")
				ElseIf IniRead($sProfilePath & "\[01] Main\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Main")							
				Else
					SetLog("You don't have other profiles configured for multy-farming. Swithing accounts canceled.", $COLOR_RED)
					PrepareForPersonalBreak($iModSource)
				EndIF
			Else
				If IniRead($sProfilePath & "\[01] Main\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Main")	
				Else					
					PrepareForPersonalBreak($iModSource)
				EndIF
			EndIf
			
		ElseIf $sCurrProfile = "[03] Third" Then
			If $iAccount = "4" Then
				If IniRead($sProfilePath & "\[04] Fourth\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Fourth")
				ElseIf IniRead($sProfilePath & "\[01] Main\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Main")		
				ElseIf IniRead($sProfilePath & "\[02] Second\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Second")
				Else
					SetLog("You don't have other profiles configured for multy-farming. Swithing accounts canceled.", $COLOR_RED)
					PrepareForPersonalBreak($iModSource)
				EndIf

			ElseIf $iAccount = "3" Then
				If IniRead($sProfilePath & "\[01] Main\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
					SwitchAccount("Main")							
				Else					
					PrepareForPersonalBreak($iModSource)
				EndIF

			EndIf
		ElseIf $sCurrProfile = "[04] Fourth" Then
			If IniRead($sProfilePath & "\[01] Main\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
				SwitchAccount("Main")		
			ElseIf IniRead($sProfilePath & "\[02] Second\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
				SwitchAccount("Second")
			ElseIf IniRead($sProfilePath & "\[03] Third\config.ini", "MOD", "MultyFarming", "0") = "1" Then	
				SwitchAccount("Third")
			Else
				SetLog("You don't have other profiles configured for multy-farming. Swithing accounts canceled.", $COLOR_RED)
				PrepareForPersonalBreak($iModSource)
			EndIf
		EndIf
	Else
		PrepareForPersonalBreak($iModSource)
	EndIf
	; IceCube (Multy-Farming Revamp v1.6)
	
EndFunc   ;==>checkAttackDisable

; IceCube (Multy-Farming Revamp v1.6)
Func PrepareForPersonalBreak($iModSource)
		Setlog("Time for break, exit now..", $COLOR_BLUE)

		; Find and wait for the confirmation of exit "okay" button
		Local $i = 0 ; Reset Loop counter
		While 1
			checkObstacles()
			BS1BackButton()
			If _Sleep($iDelayAttackDisable1000) Then Return ; wait for window to open
			If ClickOkay("ExitCoCokay", True) = True Then ExitLoop ; Confirm okay to exit
			If $i > 10 Then
				Setlog("Can not find Okay button to exit CoC, Forcefully Closing CoC", $COLOR_RED)
				If $debugImageSave = 1 Then DebugImageSave("CheckAttackDisableFailedButtonCheck_")
				CloseCoC()
				ExitLoop
			EndIf
			$i += 1
		WEnd

		If _Sleep(1000) Then Return ; short wait for CoC to exit
		PushMsg("TakeBreak")

		; CoC is closed >>
		If $iModSource = $iTaBChkTime And $aShieldStatus[0] <> "guard" Then
			Setlog("Personal Break Reset log off: " & $iValueSinglePBTimeForced & " Minutes", $COLOR_BLUE)
			WaitnOpenCoC($iValueSinglePBTimeForced * 60 * 1000, True) ; Log off CoC for user set time in expert tab
		Else
			WaitnOpenCoC(20000, True) ; close CoC for 20 seconds to ensure server logoff, True=call checkmainscreen to clean up if needed
		EndIf
		$sPBStartTime = "" ; reset Personal Break global time value to get update
		For $i = 0 To UBound($aShieldStatus) - 1
			$aShieldStatus[$i] = "" ; reset global shield info array
		Next
EndFunc   ;==>PrepareForPersonalBreak
; IceCube (Multy-Farming Revamp v1.6)
