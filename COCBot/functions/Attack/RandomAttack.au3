; #FUNCTION# ====================================================================================================================
; Name ..........: RandomAttack & RandomAttaclCloseCoC
; Description ...: Randomizes Halt Attack and close the CoC
; Syntax ........: RandomAttack() | RandomAttaclCloseCoC()
; Parameters ....:
; Return values .: None
; Author ........: ProMac 04-2016
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func RandomAttack()

	; determinate |$TimeToStop| a randomize run the Bot from 3 hours to 6 Hours
	If $icmbBotCond = 22 and $RandomTimer Then
		$sTimerRandomHalt = TimerInit()
		$TimeToStop = random(180, 359, 1)* 60000 ; 60000 = 1 Minute | 3 hours to 6 Hours (180-359)
		$RandomTimer = False
		Local $Dummy_Time, $Dummy_Hours, $Dummy_Minutes, $Dummy_Seconds
		$Dummy_Time = $TimeToStop
		_TicksToTime( $Dummy_Time, $Dummy_Hours, $Dummy_Minutes, $Dummy_Seconds)
		SetLog("Bot will run for: " & $Dummy_Hours & " hours, " & $Dummy_Minutes & " minutes", $COLOR_BLUE)
		Return False
	EndIf

	; determinate if is to close the CoC
	If $icmbBotCond = 22 and Round(TimerDiff($sTimerRandomHalt)) > $TimeToStop and $RandomTimer = False Then Return True

EndFunc

Func RandomAttaclCloseCoC()

	Local $Dummy_Hours, $Dummy_Minutes, $Dummy_Seconds

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

	; short wait for CoC to exit
	If _Sleep(1500) Then Return

	; Pushbullet Msg
	PushMsg("TakeBreak")

	; Random between 40 minutes - 2 Hours (40-180)
	Local $iRemainCoCClose = random(40, 120, 1) * 60000

	_TicksToTime($iRemainCoCClose , $Dummy_Hours, $Dummy_Minutes, $Dummy_Seconds)
	SetLog("Bot will pause for: " & $Dummy_Hours & " hours, " & $Dummy_Minutes & " minutes", $COLOR_BLUE)

	; Log off CoC for user set time in troops tab
	WaitnOpenCoC($iRemainCoCClose , True)

	; Next RandomAttack() will determinate the next random run bot time
	$RandomTimer = True

EndFunc

