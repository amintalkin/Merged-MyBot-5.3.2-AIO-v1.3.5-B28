; #CLASS# ====================================================================================================================
; Name ..........: standardAttack
; Description ...: Contains function to set up vectors for standard side attacks, and drop any remaining troops
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Shuffles the sides, so that if less than 4 sides the sides chosen are random
Func shuffleSides(ByRef $sides, $nbSides)
    Local $oldIndex = 0, $newIndex = 0, $originalValue = -1

    ; Shuffle the array so the sides are randomized
	For $i = 1 To UBound($sides) * 3
        $oldIndex = Random(0, UBound($sides) - 1, 1)
        $newIndex = Random(0, UBound($sides) - 1, 1)

		; Store the original values for the move
        $originalValue = $sides[$oldIndex]

        ; Store the new values in the index
		$sides[$oldIndex] = $sides[$newIndex]		
		; Store the original values in the new index
        $sides[$newIndex] = $originalValue
    Next

	; Redimension the array so it only has the number of sides we are interested in
	ReDim $sides[$nbSides]
	; Resort array so the sides deploy in order
	_ArraySort($sides)
	
	Return $sides
EndFunc   ;==>shuffleSides

; Drop remaining troops
Func dropRemainingTroopsStandard($sides, $nbSides = 1)
	SetLog("Dropping left over troops", $COLOR_BLUE)
	PrepareAttack($iMatchMode, True) ; Check remaining quantities
	
	Local $dropVectors[0][0], $listInfoDeploy = $DEFAULT_REMAINING_TROOPS_DEPLOY

	; Setup the attack vectors for the troops
	standardAttackVectors($dropVectors, $listInfoDeploy, $sides, $nbSides)

	If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
		launchStandardByTroops($dropVectors, $listInfoDeploy, -1, -1, -1, -1, $nbSides)
	Else
		launchStandardBySides($dropVectors, $listInfoDeploy, -1, -1, -1, -1, $nbSides)
	EndIf
EndFunc   ;==>dropRemainingTroopsStandard

; Set up the vectors to deploy troops
Func standardAttackVectors(ByRef $dropVectors, $listInfoDeploy, $sides, $nbSides)
	If Not IsArray($dropVectors) Or Not IsArray($listInfoDeploy) Or Not IsArray($sides) Then Return
	
	; Start the timer for drop point creation
	Local $hTimer = TimerInit()	
	SetLog("Calculating attack vectors for all troop deployments, please be patient...", $COLOR_PURPLE)

	ReDim $dropVectors[UBound($listInfoDeploy)][$nbSides]
		
	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount, $waveDrop
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If IsString($kind) And ($kind = "CC" Or $kind = "HEROES") Then
			For $j = 0 To $nbSides - 1
				addVector($dropVectors, $i, $j, $sides[$j], $directionRight, 0, 10)
			Next			
		ElseIf $kind < $eKing And $aDeployButtonPositions[$kind] <> -1 Then
			$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
			$unitCount[$kind] -= $dropAmount
			
			For $j = 0 To $nbSides - 1
				$waveDrop = Ceiling($dropAmount / ($nbSides - $j))
				$dropAmount -= $waveDrop

				If $waveDrop > 0 Then
					If $position = 0 Or $waveDrop < $position Then $position = $waveDrop

					addVector($dropVectors, $i, $j, $sides[$j], $directionRight, 0, $position)
				EndIf
			Next
		EndIf
	Next
	
	SetLog("Drop points created in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds!", $COLOR_PURPLE)
EndFunc   ;==>standardAttackVectors