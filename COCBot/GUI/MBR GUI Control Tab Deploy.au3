; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Controls Deploy
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: LunaEclipse(January, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func txtTownHall()
	$valueTownHall = GUICtrlRead($txtTownHall)
EndFunc   ;==>txtTownHall

Func txtDEStorage()
	$valueDEStorage = GUICtrlRead($txtDEStorage)
EndFunc   ;==>txtDEStorage

Func txtGoldStorage()
	$valueGoldStorage = GUICtrlRead($txtGoldStorage)
EndFunc   ;==>txtGoldStorage

Func txtElixirStorage()
	$valueElixirStorage = GUICtrlRead($txtElixirStorage)
EndFunc   ;==>txtElixirStorage

Func txtGoldMine()
	$valueGoldMine = GUICtrlRead($txtGoldMine)
EndFunc   ;==>txtGoldMine

Func txtElixirCollector()
	$valueElixirCollector = GUICtrlRead($txtElixirCollector)
EndFunc   ;==>txtElixirCollector

Func txtDEDrill()
	$valueDEDrill = GUICtrlRead($txtDEDrill)
EndFunc   ;==>txtDEDrill

Func cmbDeploy($troopSlot)
	$deployValues[$troopSlot][0] = _GUICtrlComboBox_GetCurSel(@GUI_CtrlId)
EndFunc   ;==>cmbDeploy

Func txtDeployStyle($troopSlot)
	Local $inputValue = StringUpper(GUICtrlRead(@GUI_CtrlId))

	If StringRight($inputValue, 1) = "R" Or StringRight($inputValue, 1) = "L" Then
		If $deployValues[$troopSlot][0] = $eDeployUnused Then
			$deployValues[$troopSlot][1] = String($inputValue)
		ElseIf $deployValues[$troopSlot][0] >= $eLSpell Then
			If StringLen($inputValue) > 1 Then
				$deployValues[$troopSlot][1] = StringLeft($inputValue, StringLen($inputValue) - 1) & StringRight($inputValue, 1)
			Else
				$deployValues[$troopSlot][1] = $inputValue
			EndIf
		Else
			$deployValues[$troopSlot][1] = StringRight($inputValue, 1)
		EndIf
	Else
		$deployValues[$troopSlot][1] = String($inputValue)
	EndIf

	GUICtrlSetData(@GUI_CtrlId, $deployValues[$troopSlot][1])
EndFunc   ;==>txtDeployStyle

Func btnReset()
	deployArrayToUISettings()
EndFunc   ;==>chkDontEndBattle