; #CLASS# ====================================================================================================================
; Name ..........: standardAttack
; Description ...: Contains functions for standard attacks
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Returns and array of how many troops must be dropped in each wave
Func standardCalculateWaveDropAmounts($listInfoDeploy)
	If Not IsArray($listInfoDeploy) Then Return
	
	Local $result[UBound($listInfoDeploy)]
	
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()
	Local $barPosition = -1, $dropAmount = 0
	Local $kind, $nbSides, $waveNumber, $waveCount, $position, $remainingWaves
	
	For $i = 0 To UBound($listInfoDeploy) - 1			
		$kind = $listInfoDeploy[$i][0]
		$nbSides = $listInfoDeploy[$i][1]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If IsNumber($kind) And $kind < $eKing Then
			$barPosition = $aDeployButtonPositions[$kind]

			If $barPosition <> -1 Then 
				$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
				$unitCount[$kind] -= $dropAmount
				
				$result[$i] = $dropAmount
			EndIf
		EndIf
	Next
	
	Return $result
EndFunc   ;==>standardCalculateWaveDropAmounts

; Function to actually deploy the troops
Func standardDeployTroops($dropVectors, $waveNumber, $sideNumber, $barPosition, $dropAmount, $position = 0)
	If $dropAmount = 0 Or isProblemAffect(True) Then Return False

	If $position = 0 Or $dropAmount < $position Then $position = $dropAmount

	Local $troopsLeft = $dropAmount
	Local $troopsPerSlot = 0

	If _SleepAttack($iDelayLaunchTroop21) Then Return
	SelectDropTroop($barPosition) ; Select Troop
	If _SleepAttack($iDelayLaunchTroop23) Then Return

	For $i = 0 To $position - 1
		$troopsPerSlot = Ceiling($troopsLeft / ($position - $i)) ; progressively adapt the number of drops to fill at the best

		standardSideDrop($dropVectors, $waveNumber, $sideNumber, $i, $troopsPerSlot, True)

		$troopsLeft -= ($troopsLeft < $troopsPerSlot) ? $troopsLeft : $troopsPerSlot
	Next
	
	Return True
EndFunc   ;==>standardDeployTroops

; Function to process attack when you doing all troops for a side before moving to the next side
Func launchStandardBySides($dropVectors, $listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides = 1)
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = standardCalculateWaveDropAmounts($listInfoDeploy)
	Local $barPosition = -1, $dropAmount = 0

	Local $isCCDropped = False, $isHeroesDropped = False
	Local $dropPoints, $dropPointCC, $dropPointKing, $dropPointQueen, $dropPointWarden
	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves
	
	For $j = 0 To $nbSides - 1
		For $i = 0 To UBound($listInfoDeploy) - 1			
			$kind = $listInfoDeploy[$i][0]
			$waveNumber = $listInfoDeploy[$i][2]
			$waveCount = $listInfoDeploy[$i][3]
			$position = $listInfoDeploy[$i][4]
			$remainingWaves = ($waveCount - $waveNumber) + 1

			If IsString($kind) Then
				If $CC <> -1 And $kind = "CC" Then
					$dropPoints = $dropVectors[$i][Random(0, $nbSides - 1, 1)]
					$dropPointCC = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
					
					If IsArray($dropPointCC) And UBound($dropPointCC) >=2 Then
						dropCC($dropPointCC[0], $dropPointCC[1], $CC)
						$isCCDropped = True
					EndIf
				ElseIf $kind = "HEROES" Then
					$dropPoints = $dropVectors[$i][Random(0, $nbSides - 1, 1)]

					If $King <> -1 Then
						$dropPointKing = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
						If IsArray($dropPointKing) And UBound($dropPointKing) >=2 Then 
							dropHeroes($dropPointKing[0], $dropPointKing[1], $King, -1, -1)
							$isHeroesDropped = True
						EndIf
					EndIf

					If $Queen <> -1 Then
						$dropPointQueen = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
						If IsArray($dropPointQueen) And UBound($dropPointQueen) >=2 Then 
							dropHeroes($dropPointQueen[0], $dropPointQueen[1], -1, $Queen, -1)
							$isHeroesDropped = True
						EndIf
					EndIf
					
					If $Warden <> -1 Then
						$dropPointWarden = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
						If IsArray($dropPointWarden) And UBound($dropPointWarden) >=2 Then
							dropHeroes($dropPointWarden[0], $dropPointWarden[1], -1, -1, $Warden)
							$isHeroesDropped = True
						EndIf
					EndIf
				EndIf
			ElseIf $kind < $eKing Then
				$barPosition = $aDeployButtonPositions[$kind]

				If $barPosition <> -1 Then
					$dropAmount = Ceiling($unitCount[$i] / ($nbSides - $j))
					$unitCount[$i] -= $dropAmount

					If $dropAmount > 0 Then
						SetLog("Dropping " & getWaveName($waveNumber, $waveCount * $nbSides) & " wave of " & $dropAmount & " " & getTranslatedTroopName($kind), $COLOR_GREEN)
						If standardDeployTroops($dropVectors, $i, $j, $barPosition, $dropAmount, $position) Then
							If _SleepAttack(SetSleep(1)) Then Return
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>launchStandardBySides

; Function to process attack when you doing all sides for a troop before moving to the next troop
Func launchStandardByTroops($dropVectors, $listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides = 1)
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()
	Local $barPosition = -1, $dropAmount = 0

	Local $isCCDropped = False, $isHeroesDropped = False
	Local $dropPoints, $dropPointCC, $dropPointKing, $dropPointQueen, $dropPointWarden
	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount, $waveDrop

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If IsString($kind) Then
			If $CC <> -1 And $kind = "CC" Then
				$dropPoints = $dropVectors[$i][Random(0, $nbSides - 1, 1)]
				$dropPointCC = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
				
				If IsArray($dropPointCC) And UBound($dropPointCC) >=2 Then
					dropCC($dropPointCC[0], $dropPointCC[1], $CC)
					$isCCDropped = True
				EndIf
			ElseIf $kind = "HEROES" Then
				$dropPoints = $dropVectors[$i][Random(0, $nbSides - 1, 1)]

				If $King <> -1 Then
					$dropPointKing = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
					If IsArray($dropPointKing) And UBound($dropPointKing) >=2 Then 
						dropHeroes($dropPointKing[0], $dropPointKing[1], $King, -1, -1)
						$isHeroesDropped = True
					EndIf
				EndIf

				If $Queen <> -1 Then
					$dropPointQueen = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
					If IsArray($dropPointQueen) And UBound($dropPointQueen) >=2 Then 
						dropHeroes($dropPointQueen[0], $dropPointQueen[1], -1, $Queen, -1)
						$isHeroesDropped = True
					EndIf
				EndIf
				
				If $Warden <> -1 Then
					$dropPointWarden = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
					If IsArray($dropPointWarden) And UBound($dropPointWarden) >=2 Then
						dropHeroes($dropPointWarden[0], $dropPointWarden[1], -1, -1, $Warden)
						$isHeroesDropped = True
					EndIf
				EndIf
			EndIf
		ElseIf $kind < $eKing Then
			$barPosition = $aDeployButtonPositions[$kind]

			If $barPosition <> -1 Then
				$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
				$unitCount[$kind] -= $dropAmount
				SetLog("Dropping " & getWaveName($waveNumber, $waveCount) & " wave of " & $dropAmount & " " & getTranslatedTroopName($kind), $COLOR_GREEN)

				For $j = 0 To $nbSides - 1
					$waveDrop = Ceiling($dropAmount / ($nbSides - $j))
					$dropAmount -= $waveDrop
					
					If $waveDrop > 0 Then
						If standardDeployTroops($dropVectors, $i, $j, $barPosition, $waveDrop, $position) Then
							If _SleepAttack(SetSleep(1)) Then Return
						EndIf
					EndIf
				Next	
			EndIf
		EndIf
	Next	
EndFunc   ;==>launchStandardByTroops

; Main function for processing standard side attack
Func launchStandard($listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides = 1)
	Local $dropVectors[0][0]
	Local $sides = [$sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight]

	; Shuffle the sides so when less then four sides, the sides are chosen randomly
	shuffleSides($sides, $nbSides)

	; Setup the attack vectors for the troops
	standardAttackVectors($dropVectors, $listInfoDeploy, $sides, $nbSides)

	If $debugSetlog = 1 Then SetLog("Launch Standard Attack with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)
	
	If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
		launchStandardByTroops($dropVectors, $listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides)
	Else
		launchStandardBySides($dropVectors, $listInfoDeploy, $CC, $King, $Queen, $Warden, $nbSides)
	EndIf

	If _SleepAttack($iDelayalgorithm_AllTroops4) Then Return

	dropRemainingTroopsStandard($sides, $nbSides) ; Use remaining troops
	useHeroesAbility() ; Use heroes abilities

	If $usingAllSides Then $usingAllSides = False

	SetLog("Finished Attacking, waiting for the battle to end")
	Return True
EndFunc   ;==>launchStandard