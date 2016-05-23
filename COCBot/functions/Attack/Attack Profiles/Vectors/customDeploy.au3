; #CLASS# ====================================================================================================================
; Name ..........: customDeploy
; Description ...: Contains function to set up vectors for custom deployment, and drop any remaining troops
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Drop remaining troops
Func dropRemainingTroopsCustom($side)
	SetLog("Dropping left over troops", $COLOR_BLUE)
	PrepareAttack($iMatchMode, True) ; Check remaining quantities

	Local $dropVectors[0][0], $listInfoDeploy = $DEFAULT_REMAINING_TROOPS_DEPLOY

	; Setup the attack vectors for the troops
	customDeployVectors($dropVectors, $listInfoDeploy, $side)
	
	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()
	Local $barPosition = -1

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If $kind < $eKing Then
			$barPosition = $aDeployButtonPositions[$kind]
			
			If $barPosition <> -1 Then
				$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
				$unitCount[$kind] -= $dropAmount

				If $dropAmount > 0 Then
					SetLog("Dropping " & getWaveName($waveNumber, $waveCount) & " wave of " & $dropAmount & " " & getTranslatedTroopName($kind), $COLOR_GREEN)

					If customDeployTroops($dropVectors, $i, $barPosition, $dropAmount, $position) Then
						If _SleepAttack(SetSleep(1)) Then Return
					EndIf
				EndIf				
			EndIf
		EndIf
	Next
EndFunc   ;==>dropRemainingTroopsCustom

; Set up the vectors to deploy troops
Func customDeployVectors(ByRef $dropVectors, $listInfoDeploy, $side)
	If Not IsArray($dropVectors) Or Not IsArray($listInfoDeploy) Then Return
	
	; Start the timer for drop point creation
	Local $hTimer = TimerInit()	
	SetLog("Calculating attack vectors for all troop deployments, please be patient...", $COLOR_PURPLE)

	ReDim $dropVectors[UBound($listInfoDeploy)][1]
	
	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If $kind < $eLSpell And $aDeployButtonPositions[$kind] <> -1 Then
			Switch $kind
				Case $eKing, $eQueen, $eWarden, $eCastle
					addVector($dropVectors, $i, 0, $side, $directionRight, 0, 10)
				Case Else
					$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
					$unitCount[$kind] -= $dropAmount

					If $dropAmount > 0 Then
						If $position = 0 Or $dropAmount < $position Then $position = $dropAmount

						addVector($dropVectors, $i, 0, $side, $directionRight, 0, $position)
					EndIf					
			EndSwitch
		EndIf
	Next
	
	SetLog("Drop points created in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds!", $COLOR_PURPLE)
EndFunc   ;==>customDeployVectors