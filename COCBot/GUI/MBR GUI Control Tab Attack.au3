; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), LunaEclipse(April, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkDBSmartAttackRedArea()
	Switch _GUICtrlComboBox_GetCurSel($cmbDBDeploy)
		Case $eOneSide, $eTwoSides, $eThreeSides, $eAllSides
			GUICtrlSetData($cmbDBUnitDelay, "|0|1|5|10|11|12|13|14|15", "10")
			GUICtrlSetData($cmbDBWaveDelay, "|0|1|2|3|4|5|10|20|25", "10")

			GUICtrlSetState($lblDBSmartDeploy, $GUI_SHOW)
			GUICtrlSetState($cmbDBSmartDeploy, $GUI_SHOW)

			For $i = $chkDBAttackNearGoldMine To $picDBAttackNearDarkElixirDrill
				GUICtrlSetState($i, $GUI_HIDE)
			Next
		Case $eSmartSave
			GUICtrlSetData($cmbDBUnitDelay, "|1|2|3|4|5|6|7|8", "5")
			GUICtrlSetData($cmbDBWaveDelay, "|1|2|4|6|8", "4")

			GUICtrlSetState($lblDBSmartDeploy, $GUI_HIDE)
			GUICtrlSetState($cmbDBSmartDeploy, $GUI_HIDE)

			For $i = $chkDBAttackNearGoldMine To $picDBAttackNearDarkElixirDrill
				GUICtrlSetState($i, $GUI_SHOW)
			Next
		Case Else
			; Should never get here unless there is a problem with the code
	EndSwitch
	
		_GUICtrlComboBox_SetCurSel($cmbDBUnitDelay, $iCmbUnitDelay[$DB])
		_GUICtrlComboBox_SetCurSel($cmbDBWaveDelay, $iCmbWaveDelay[$DB])

EndFunc   ;==>chkDBSmartAttackRedArea

Func chkABSmartAttackRedArea()
	chkDESideEB()
 	Switch _GUICtrlComboBox_GetCurSel($cmbABDeploy)
		Case $eCustomDeploy
			GUICtrlSetState($btnMilkingOptions, $GUI_HIDE)

			For $i = $lblABSmartDeploy To $picABAttackNearDarkElixirDrill
				GUICtrlSetState($i, $GUI_HIDE)
			Next

			For $i = 0 to $DEPLOY_MAX_WAVES - 1
				GUICtrlSetState($ctrlDeploy[$i][1], $GUI_ENABLE)
				GUICtrlSetState($ctrlDeploy[$i][2], $GUI_ENABLE)
			Next
		Case $eMilking
			GUICtrlSetState($btnMilkingOptions, $GUI_SHOW)

			For $i = $lblABSmartDeploy To $picABAttackNearDarkElixirDrill
				GUICtrlSetState($i, $GUI_SHOW)
			Next
		Case Else
			GUICtrlSetState($btnMilkingOptions, $GUI_HIDE)

			GUICtrlSetState($lblABSmartDeploy, $GUI_SHOW)
			GUICtrlSetState($cmbABSmartDeploy, $GUI_SHOW)

			For $i = $chkABAttackNearGoldMine To $picDBAttackNearDarkElixirDrill
				GUICtrlSetState($i, $GUI_HIDE)
			Next
	EndSwitch
EndFunc  ;==>chkABSmartAttackRedArea

Func chkBalanceDR()
	If GUICtrlRead($chkUseCCBalanced) = $GUI_CHECKED Then
		GUICtrlSetState($cmbCCDonated, $GUI_ENABLE)
		GUICtrlSetState($cmbCCReceived, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbCCDonated, $GUI_DISABLE)
		GUICtrlSetState($cmbCCReceived, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBalanceDR

Func cmbBalanceDR()
	If _GUICtrlComboBox_GetCurSel($cmbCCDonated) = _GUICtrlComboBox_GetCurSel($cmbCCReceived) Then
		_GUICtrlComboBox_SetCurSel($cmbCCDonated, 0)
		_GUICtrlComboBox_SetCurSel($cmbCCReceived, 0)
	EndIf
EndFunc   ;==>cmbBalanceDR

Func chkDBRandomSpeedAtk()
	If GUICtrlRead($chkDBRandomSpeedAtk) = $GUI_CHECKED Then
		;$iChkDBRandomSpeedAtk = 1
		GUICtrlSetState($cmbDBUnitDelay, $GUI_DISABLE)
		GUICtrlSetState($cmbDBWaveDelay, $GUI_DISABLE)
	Else
		;$iChkDBRandomSpeedAtk = 0
		GUICtrlSetState($cmbDBUnitDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbDBWaveDelay, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkDBRandomSpeedAtk

Func chkABRandomSpeedAtk()
	If GUICtrlRead($chkABRandomSpeedAtk) = $GUI_CHECKED Then
		;$iChkABRandomSpeedAtk = 1
		GUICtrlSetState($cmbABUnitDelay, $GUI_DISABLE)
		GUICtrlSetState($cmbABWaveDelay, $GUI_DISABLE)
	Else
		;$iChkABRandomSpeedAtk = 0
		GUICtrlSetState($cmbABUnitDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbABWaveDelay, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkABRandomSpeedAtk

Func btnMilkingOptions()
	OpenGUIMilk2()
EndFunc   ;==>btnMilkingOptions

Func cmbABDeploy()
	chkDESideEB()
	If _GUICtrlComboBox_GetCurSel($cmbABDeploy) = $eMilking Then
		GUICtrlSetState($btnMilkingOptions, $GUI_ENABLE)
	Else
		GUICtrlSetState($btnMilkingOptions, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABRandomSpeedAtk

Func chkDBHeroWait()
	If GUICtrlRead($chkDBKingWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBKingAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBKingWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkDBQueenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBQueenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBQueenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkDBWardenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBWardenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBWardenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf
EndFunc   ;==>cmbABDeploy

Func chkABHeroWait()
	If GUICtrlRead($chkABKingWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABKingAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABKingWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkABQueenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABQueenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABQueenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkABWardenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABWardenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABWardenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf
EndFunc   ;==>chkABHeroWait