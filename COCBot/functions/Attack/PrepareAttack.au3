; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $atkTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......: LunaEclipse(January, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func IsUnitAlreadyOnBar($aBarArray, $pTroopType, $index)
	If Not IsArray($aBarArray) Then Return False ; Prevent errors

	Local $return = False
	Local $i = 0

	; This loops through the bar array but allows us to exit as soon as we find our match.
	For $i = 0 To $index - 1
		; $aBarArray[$i][0] holds the unit ID for that position on the deployment bar.
		If $aBarArray[$i][0] = $pTroopType Then
			$return = True
			ExitLoop
		EndIf
	Next

	Return $return
EndFunc   ;==>IsUnitAlreadyOnBar

Func IsTroopToBeUsed($pMatchMode, $pTroopType)
	If $pMatchMode = $DT Or $pMatchMode = $TB Or $pMatchMode = $TS Then Return True

	Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]

	For $x = 0 To UBound($tempArr) - 1
		If $tempArr[$x] = $pTroopType Then
			Return True
		EndIf
	Next

	Return False
EndFunc   ;==>IsTroopToBeUsed

Func PrepareAttack($pMatchMode, $Remaining = False) ; Assigns troops
	Local $result, $troopData, $kind
	Local $aTemp[12][3], $aTroopDataList
	Local $barCounter = 0

	If $debugSetlog = 1 Then SetLog("PrepareAttack", $COLOR_PURPLE)

	; Clear the variables to make sure there is no old data in it
	Dim $atkTroops[12][2]
	$CCSpellType = -1

	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $sModeText[$pMatchMode], $COLOR_BLUE)
	Else
		SetLog("Initiating attack for: " & $sModeText[$pMatchMode], $COLOR_RED)
	EndIf

	_CaptureRegion2(0, 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	If _SleepAttack($iDelayPrepareAttack1) Then Return

	; SuspendAndroid()
	$result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
	If $debugSetlog = 1 Then SetLog("First Search of Troopsbar, getting units and spells", $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result[0], $COLOR_PURPLE)

	$aTroopDataList = StringSplit($result[0], "|", $STR_NOCOUNT)

	If $result[0] <> "" Then
		For $i = 0 To UBound($aTroopDataList) - 1
			$troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)

			$aTemp[$troopData[1]][0] = $troopData[0]
			$aTemp[$troopData[1]][1] = $troopData[2]

			$barCounter = $troopData[1] + 1
		Next
	EndIf

	; Check to see if a second copy of any of the dark elixir spells exists, as this will be a Clan Castle Spell
	_CaptureRegion2(GetXPosofArmySlot($barCounter, 68), 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	If _SleepAttack($iDelayPrepareAttack1) Then Return

	$result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
	If $debugSetlog = 1 Then Setlog("Second Search of Troopsbar, checking for CC Spells", $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result[0], $COLOR_PURPLE)

	$aTroopDataList = StringSplit($result[0], "|", $STR_NOCOUNT)

	If $result[0] <> "" Then
		For $i = 0 To UBound($aTroopDataList) - 1
			$troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)

			If IsUnitAlreadyOnBar($aTemp, $troopData[0], $barCounter + $troopData[1]) Then
				$aTemp[$barCounter + $troopData[1]][0] = $eCCSpell
				$CCSpellType = $troopData[0]
			Else
				$aTemp[$barCounter + $troopData[1]][0] = $troopData[0]
			EndIf
			$aTemp[$barCounter + $troopData[1]][1] = $troopData[2]
		Next
	EndIf

	For $i = 0 To UBound($aTemp) - 1
		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
			$atkTroops[$i][0] = -1
			$atkTroops[$i][1] = 0
		Else
			$kind = $aTemp[$i][0]
			If $kind < $eKing And Not IsTroopToBeUsed($pMatchMode, $kind) Then
				$atkTroops[$i][0] = -1
				$kind = -1
			Else
				$atkTroops[$i][0] = $kind
			EndIf

			Switch $kind
				Case -1
					$atkTroops[$i][1] = 0
				Case $eKing, $eQueen, $eWarden, $eCastle
					$atkTroops[$i][1] = ""
				Case $eCCSpell
					$atkTroops[$i][1] = 1
				Case Else
					$atkTroops[$i][1] = $aTemp[$i][1]
			EndSwitch

			If $kind <> -1 Then
				If $kind = $eCCSpell Then
					SetLog("-*-" & "Clan Castle Spell: " & getTranslatedTroopName($CCSpellType), $COLOR_GREEN)
				Else
					If $atkTroops[$i][1] = "" Then
						SetLog("-*-" & getTranslatedTroopName($kind), $COLOR_GREEN)
					Else
						SetLog("-*-" & getTranslatedTroopName($kind) & ": " & $atkTroops[$i][1], $COLOR_GREEN)
					EndIf
				EndIf
			EndIf
		EndIf
	Next

    ; ResumeAndroid()
EndFunc   ;==>PrepareAttack
