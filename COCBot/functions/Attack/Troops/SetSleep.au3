; #FUNCTION# ====================================================================================================================
; Name ..........: SetSleep
; Description ...: Randomizes deployment wait time
; Syntax ........: SetSleep($type)
; Parameters ....: $type                - Flag for type return desired.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (June2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SetSleep($type)
	If IsKeepClicksActive() = True Then Return 0 ; fast bulk deploy

	If $AndroidAdbClick = True Then
		; adjust for slow ADB clicks the delay factor
		Local $factor0 = 10
		Local $factor1 = 100
	Else
		Local $factor0 = 10
		Local $factor1 = 100
	EndIf
	
	If $iMatchMode = $DB And $iChkDeploySettings[$DB] = $eSmartSave And Not $usingAllSides Then
		Local $aUnitDelay[8] = [1, 2, 3, 4, 5, 6, 7, 8]
		Local $aWaveDelay[4] = [2, 4, 6, 8]
	Else
		Local $aUnitDelay[8] = [1, 5, 10, 11, 12, 13, 14, 15]
		Local $aWaveDelay[4] = [5, 10 , 20 , 25]
	EndIf
	
	Switch $type
		Case 0
			If $iChkRandomspeedatk[$iMatchMode] = 1 Then
				Return Number($aUnitDelay[Random(0, UBound($aUnitDelay) - 1, 1)]) * $factor0 ; random deploying click [10ms to 150ms]
			Else
				Return Number($aUnitDelay[$iCmbUnitDelay[$iMatchMode]]) * $factor0
			EndIf
		Case 1
			If $iChkRandomspeedatk[$iMatchMode] = 1 Then
				Return Number($aWaveDelay[Random(0, UBound($aWaveDelay) - 1, 1)]) * $factor1 ; random delay between waves [500ms to 2500ms]
			Else
				Return Number($aWaveDelay[$iCmbWaveDelay[$iMatchMode]]) * $factor1
			EndIf
	EndSwitch
EndFunc   ;==>SetSleep

; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepAttack
; Description ...: Version of _Sleep() used in attack code so active keep clicks mode doesn't slow down bulk deploy
; Syntax ........: see _Sleep
; Parameters ....: see _Sleep
; Return values .: see _Sleep
; Author ........: cosote (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepAttack($iDelay, $iSleep = True)
	If $RunState = False Then
		ResumeAndroid()
		Return True
	EndIf
	If IsKeepClicksActive() = True Then Return False
	Return _Sleep($iDelay, $iSleep)
EndFunc   ;==>_SleepAttack
