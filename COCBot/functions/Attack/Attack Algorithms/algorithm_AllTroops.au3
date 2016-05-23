; #CLASS# ====================================================================================================================
; Name ..........: algorithm_AllTroops
; Description ...: This file contens all functions to manage attack profiles
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Wrapper function to support CSV so no modifications needs to be made to CSV
Func SetSlotSpecialTroops()
	; Just call the new getHeroes() function
	getHeroes()
EndFunc   ;==>SetSlotSpecialTroops

; Function to close battle without checking normal end battle conditions
Func CloseBattle($overrideStarCheck = False)
	$skipReturnHome = True
	
	If Not $overrideStarCheck Then
		For $i = 1 To 30
			If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ; exit if not 'no star'
			If _SleepAttack($iDelayalgorithm_AllTroops2) Then Return
		Next
	EndIf
	
	If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ; Click Surrender
	If _SleepAttack($iDelayalgorithm_AllTroops3) Then Return

	If IsEndBattlePage() Then
		ClickP($aConfirmSurrender, 1, 0, "#0031") ; Click Confirm
		If _SleepAttack($iDelayalgorithm_AllTroops1) Then Return
	EndIf
EndFunc   ;==>CloseBattle

; Sets information about heroes into global variables
Func getHeroes()
	Local $aDeployButtonPositions = getUnitLocationArray()

	$King = $aDeployButtonPositions[$eKing]
	$Queen = $aDeployButtonPositions[$eQueen]
	$Warden = $aDeployButtonPositions[$eWarden]
	$CC = $aDeployButtonPositions[$eCastle]

	If $debugSetlog = 1 Then
		SetLog("Use king  SLOT n° " & $King, $COLOR_PURPLE)
		SetLog("Use queen SLOT n° " & $Queen, $COLOR_PURPLE)
		SetLog("Use Warden SLOT n° " & $Warden, $COLOR_PURPLE)
		SetLog("Use CC SLOT n° " & $CC, $COLOR_PURPLE)
	EndIf
EndFunc   ;==>getHeroes

; Function to actually use a heroes special ability, by clicking the appropriate troop bar button
Func useHeroesAbility()
	;Activate KQ's power
	If ($checkKPower Or $checkQPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_BLUE)
		If _SleepAttack($delayActivateKQ) Then Return

		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_BLUE)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf

		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_BLUE)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
	EndIf
EndFunc   ;==>useHeroesAbility

; Function to process town hall snipes, will exit battle after the snipe if it was a snipe only attack
Func useTownHallSnipe()
	SwitchAttackTHType()

	; Check to see if the attack type was a townhall snipe only
	If $iMatchMode = $TS Then
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf

		If $THusedKing = 1 Or $THusedQueen = 1 Then
			SetLog("King and/or Queen dropped, close attack")
		Else
			Setlog("Wait few sec before close attack")
			If _SleepAttack(Random(2, 5, 1) * 1000) Then Return ; wait 2-5 second before exit if king and queen are not dropped
		EndIf

		CloseBattle()
	EndIf
EndFunc   ;==>useTownHallSnipe

; Function returns the number of sides to attack from, based on the attack type
Func getNumberOfSides()
	Local $nbSides = 0

	; Check the attack types common to both first, case else will deal with attack types specific to a particular type of base
	Switch $iChkDeploySettings[$iMatchMode]
		Case $eOneSide
			SetLog("Attacking on a single side.", $COLOR_BLUE)
			$nbSides = 1
		Case $eTwoSides
			SetLog("Attacking on two sides.", $COLOR_BLUE)
			$nbSides = 2
		Case $eThreeSides
			SetLog("Attacking on three sides.", $COLOR_BLUE)
			$nbSides = 3
		Case $eAllSides
			SetLog("Attacking on all sides.", $COLOR_BLUE)
			$nbSides = 4
		Case Else
			If $iMatchMode = $DB Then
				Switch $iChkDeploySettings[$iMatchMode]
					Case $eSmartSave
						$nbSides = 4
					Case Else
						; Should never reach here unless there is a problem with the code
				EndSwitch
			ElseIf $iMatchMode = $LB Then
				Switch $iChkDeploySettings[$iMatchMode]
					Case $eCustomDeploy
						$nbSides = 1
					Case Else
						; Should never reach here unless there is a problem with the code
				EndSwitch
			EndIf
	EndSwitch

	Return $nbSides
EndFunc   ;==>getNumberOfSides

; Function returns the deployment array for the attack, attack type can be overridden by using the parameter
Func getDeploymentInfo($nbSides, $overrideMode = -1)
	If ($iMatchMode = $LB And $iChkDeploySettings[$LB] = $eCustomDeploy And $overrideMode = -1) Or ($iMatchMode = $LB And $overrideMode = $eCustomDeploy) Then ; Customized side wave deployment for Custom Deploy
        Local $listInfoDeploy = deployUISettingsToArray($nbSides)
		If $debugSetlog = 1 Then SetLog("List Deploy for Customized Side attack", $COLOR_PURPLE)
    ElseIf ($iMatchMode = $DB And $iChkDeploySettings[$DB] = $eSmartSave And $overrideMode = -1) Or ($iMatchMode = $DB And $overrideMode = $eSmartSave) Then ; Save Troops For Collectors Style
	    Local $listInfoDeploy = deployArraySetSides($DEFAULT_SAVE_TROOPS_DEPLOY, $nbSides)
        If $debugSetlog = 1 Then SetLog("List Deploy for Save Troops attacks", $COLOR_PURPLE)
	Else
		Local $listInfoDeploy = deployArraySetSides($DEFAULT_ORIGINAL_DEPLOY, $nbSides)
		If $debugSetlog = 1 Then SetLog("List Deploy for Standard attacks", $COLOR_PURPLE)
	EndIf

	Return $listInfoDeploy
EndFunc   ;==>getDeploymentInfo

; This function calls the appropriate attack profile for the selected attack
Func deployTroops($nbSides)
	Local $listInfoDeploy = getDeploymentInfo($nbSides)

	Switch $iMatchMode
		Case $DB
			Switch $iChkDeploySettings[$DB]
				Case $eSmartSave
					launchSaveTroopsForCollectors($listInfoDeploy, $CC, $King, $Queen, $Warden)
				Case Else
					launchStandard($listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides)
			EndSwitch
		Case $LB
			Switch $iChkDeploySettings[$LB]
				Case $eCustomDeploy
					launchCustomDeploy($listInfoDeploy, $CC, $King, $Queen, $Warden)
				Case Else
					launchStandard($listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides)
			EndSwitch
	EndSwitch
EndFunc   ;==>deployTroops

; Main function that handles all attack types to be sure the correct code runs
Func algorithm_AllTroops()
	If $debugSetlog = 1 Then Setlog("algorithm_AllTroops", $COLOR_PURPLE)

	; Calculate Redline
	calculateRedLine()

	getHeroes()
	If _SleepAttack($iDelayalgorithm_AllTroops1) Then Return

    If $iMatchMode = $TS or ($chkATH = 1 And SearchTownHallLoc()) Then
		useTownHallSnipe()

		; Only quit if the attack was a town hall snipe
		; This allows a standard attack to continue after destroying an outside town hall
		If $iMatchMode = $TS Then Return
	EndIf

	Local $nbSides = getNumberOfSides()

	If $nbSides = 0 Then Return ; No sides set, so lets just quit

	If _SleepAttack($iDelayalgorithm_AllTroops2) Then Return
	deployTroops($nbSides)
EndFunc   ;==>algorithm_AllTroops
