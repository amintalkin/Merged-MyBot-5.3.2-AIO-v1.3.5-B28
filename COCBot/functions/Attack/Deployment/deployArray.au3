; #CLASS# ====================================================================================================================
; Name ..........: deployArray
; Description ...: This file contains all functions relating to deployment arrays, including custom deployment
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

Func isDeployEmpty()
	Local $result = True

	For $i = 0 To $DEPLOY_MAX_WAVES - 1
		If _GUICtrlComboBox_GetCurSel($ctrlDeploy[$i][1]) <> $eDeployUnused Then
			$result = False
			ExitLoop
		EndIf
	Next

	Return $result
EndFunc   ;==>isDeployEmpty

Func deployArraySetSides($aDeploy, $nbSides = 1)
	Local $result[UBound($aDeploy)][UBound($aDeploy, 2)]

	For $i = 0 To UBound($aDeploy) - 1
		$result[$i][0] = $aDeploy[$i][0]
		If $aDeploy[$i][0] < $eDeployWait And $aDeploy[$i][1] = 0 Then
			$result[$i][1] = $nbSides
		Else
			$result[$i][1] = $aDeploy[$i][1]
		EndIf
		$result[$i][2] = $aDeploy[$i][2]
		$result[$i][3] = $aDeploy[$i][3]
		$result[$i][4] = $aDeploy[$i][4]
	Next

	Return $result
EndFunc   ;==>deployArraySetSides

Func deployArrayToString($deployArray = -1)
	Local $result = ""
	Local $iRows, $iColumns

	If IsArray($deployArray) Then
		$iRows = UBound($deployArray)
		$iColumns = UBound($deployArray, 2)

		For $i = 0 To $iRows - 1
			For $j = 0 To $iColumns - 1
				If $j = 0 Then
					$result &= getDeploymentFileTroopName($deployArray[$i][$j])
				Else
					$result &= $deployArray[$i][$j]
				EndIf

				If $j < $iColumns - 1 Then
					$result &= $COLUMN_SEPERATOR
				EndIf
			Next

			If $i < $iRows - 1 Then
				$result &= $ROW_SEPERATOR
			EndIf
		Next
	Else
		$deployArray = $DEFAULT_CUSTOM_DEPLOY

		For $i = 0 To $DEPLOY_MAX_WAVES - 1
			$deployValues[$i][0] = $deployArray[$i][0]
			$deployValues[$i][1] = $deployArray[$i][4]
		Next

		$result = deployArrayToString($deployValues)
	EndIf

	Return $result
EndFunc   ;==>deployArrayToString

Func deployArrayToUISettings($deployArray = -1)
	If IsArray($deployArray) Then
		For $i = 0 To UBound($deployArray) - 1
			_GUICtrlComboBox_SetCurSel($ctrlDeploy[$i][1], $deployArray[$i][0])
			GUICtrlSetData($ctrlDeploy[$i][2], $deployValues[$i][UBound($deployArray, 2) - 1])
		Next
	Else
		$deployArray = $DEFAULT_CUSTOM_DEPLOY

		For $i = 0 To $DEPLOY_MAX_WAVES - 1
			$deployValues[$i][0] = $deployArray[$i][0]
			$deployValues[$i][1] = $deployArray[$i][4]

			_GUICtrlComboBox_SetCurSel($ctrlDeploy[$i][1], $deployValues[$i][0])
			GUICtrlSetData($ctrlDeploy[$i][2], $deployValues[$i][1])
		Next
	EndIf
EndFunc   ;==>deployArrayToUISettings

Func deployStringToArray($deployString = "")
	Local $result[1][2] = [[0]]
	Local $arrayRows, $arrayColumns, $deployArray
	Local $iRows, $iColumns

	If $deployString = "" Then
		$deployArray = $DEFAULT_CUSTOM_DEPLOY

		ReDim $result[UBound($deployArray)][2]
		For $i = 0 To $DEPLOY_MAX_WAVES - 1
			$result[$i][0] = $deployArray[$i][0]
			$result[$i][1] = $deployArray[$i][4]
		Next
	Else
		$arrayRows = StringSplit($deployString, $ROW_SEPERATOR, $STR_ENTIRESPLIT + $STR_NOCOUNT)
		$iRows = UBound($arrayRows)

		For $i = 0 To $iRows - 1
			$arrayColumns = StringSplit($arrayRows[$i], $COLUMN_SEPERATOR, $STR_NOCOUNT)
			$iColumns = UBound($arrayColumns)

			If $iColumns > UBound($result) Then
				ReDim $result[$iRows][$iColumns]
			Else
				ReDim $result[$iRows][UBound($result, 2)]
			EndIf

			For $j = 0 To $iColumns - 1
				If $j = 0 Then
					$result[$i][$j] = getTroopNumber($arrayColumns[$j])
				Else
					$result[$i][$j] = $arrayColumns[$j]
				EndIf
			Next
		Next
	EndIf
	
	Return $result
EndFunc   ;==>deployStringToArray

Func deployUISettingsToArray($nbSides = 1)
	Local $result[$DEPLOY_MAX_WAVES][$DEPLOY_COLUMNS]
	Local $waveCount[$eHaSpell + 1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $waveNumber[$eHaSpell + 1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $kind = $eDeployUnused, $position = 0

	If isDeployEmpty() Then
		deployArrayToUISettings()
	Else
		For $i = 0 to UBound($deployValues, 1) - 1
			If $deployValues[$i][0] < $eDeployWait Then $waveCount[$deployValues[$i][0]] += 1
		Next

		For $i = 0 To $DEPLOY_MAX_WAVES - 1
			$kind = $deployValues[$i][0]
			$position = $deployValues[$i][1]
			$result[$i][0] = $kind
			$result[$i][1] = $nbSides

			If $kind < $eDeployWait Then
				$waveNumber[$kind] += 1
				$result[$i][2] = $waveNumber[$kind]
				$result[$i][3] = $waveCount[$kind]
			Else
				$result[$i][2] = 0
				$result[$i][3] = 0
			EndIf

			$result[$i][4] = $position
		Next
	EndIf

	Return $result
EndFunc   ;==>deployUISettingsToArray

Func loadDeployment()
	; Create a constant variable in Local scope of the message to display in FileOpenDialog.
	Local Const $sMessage = "Select the deployment file to load."
	
	Local $loadFile, $loadFile, $aFileArray, $aLineArray, $lineNumber = 0
	
	; Display an open dialog to select a list of file(s).
	$loadFile = FileOpenDialog($sMessage, @ScriptDir & "\CustomDeploy", "Custom Deployments (*.csv)", $FD_FILEMUSTEXIST)
	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file was selected.")
	Else
		; Store the contents of the file as an array, for faster reading.
		$aFileArray = FileReadToArray($loadFile)
		If @error Then
			; Display the error message.
			MsgBox($MB_SYSTEMMODAL, "", "File either could not be opened or is Empty.")
		Else
			For $i = 0 to Ubound($aFileArray) - 1
				$aLineArray = StringSplit($aFileArray[$i], ",")
				
				;Ignore headers
				If $aLineArray[1] <> $DEPLOY_TYPE_HEADER And $aLineArray[2] <> $DEPLOY_POSITION_HEADER Then
					If $lineNumber > Ubound($deployValues) - 1 Then ExitLoop ; There is more entries then allowed, we need to skip the rest.
					
					; Check to see if the type is already a number
					If StringIsDigit($aLineArray[1]) Then
						; Its a number so just store it
						$deployValues[$lineNumber][0] = $aLineArray[1]
					Else
						; Its text so convert the string to the value of the Enum
						$deployValues[$lineNumber][0] = getTroopNumber($aLineArray[1])
					EndIf

					; Store the position value
					$deployValues[$lineNumber][1] = $aLineArray[2]
					; Increase the array counter
					$lineNumber += 1
				EndIf
			Next

			; Fill in the rest of the array with unused entries
			While $lineNumber < Ubound($deployValues)
				$deployValues[$lineNumber][0] = $eDeployUnused
				$deployValues[$lineNumber][1] = 0
				$lineNumber += 1
			WEnd
		EndIf
	EndIf
EndFunc   ;==>loadDeployment

Func saveDeployment()
	; Create a constant variable in Local scope of the message to display in FileSaveDialog.
	Local Const $sMessage = "Choose a filename."
	
	Local $sDrive = "", $sDirectory = "", $sFileName = "", $sExtension = ""
	Local $aPathSplit, $aFileArray[$DEPLOY_MAX_WAVES + 1]

	; Display a save dialog to select a file.
	Local $saveFile = FileSaveDialog($sMessage, @ScriptDir & "\CustomDeploy", "Custom Deployments (*.csv)", $FD_PATHMUSTEXIST)

	If @error Then
		; Display the error message.
		MsgBox($MB_SYSTEMMODAL, "", "No file was saved.")
	Else
		 ; Split the save filename into its respective parts.
		$aPathSplit = _PathSplit($saveFile, $sDrive, $sDirectory, $sFileName, $sExtension)

		If StringLower($sExtension) <> ".csv" Then
			$sExtension = ".csv"
			$saveFile = $sDrive & $sDirectory & $sFileName & $sExtension
		EndIf

		For $i = 0 To $DEPLOY_MAX_WAVES
			If $i = 0 Then
				$aFileArray[$i] = $DEPLOY_TYPE_HEADER & "," & $DEPLOY_POSITION_HEADER
			Else
				$aFileArray[$i] = $deployValues[$i - 1][0] & "," & $deployValues[$i - 1][1]					
			EndIf
		Next

		_FileWriteFromArray($saveFile, $aFileArray)
		MsgBox($MB_SYSTEMMODAL, "", "You saved the following file:" & @CRLF & $saveFile)
	EndIf
EndFunc   ;==>saveDeployment