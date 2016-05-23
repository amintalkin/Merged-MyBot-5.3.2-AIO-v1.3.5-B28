; #CLASS# ====================================================================================================================
; Name ..........: customDeploy
; Description ...: Contains functions for custom deployment
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Determine which side has the most points, to attack from
Func determineSideFromPoints($pointsArray)
	Local $return =  Random($sideTopLeft, $sideBottomLeft, 1), $maxValue = 0, $sidePoints = 0

	If IsArray($pointsArray) Then
		For $i = 0 To UBound($pointsArray) - 1
			$sidePoints = Number($pointsArray[$i])

			If $sidePoints > $maxValue Then
				$maxValue = $sidePoints
				$return = $i
			EndIf
		Next
	EndIf

	Return $return
EndFunc   ;==>determineSideFromPoints

; Calculate points for the entries in the storages array and assign them to a side
Func calculateStoragePoints(ByRef $pointsTotal, $sourceArray, $pointValue)
	Local $coordsArray, $side = -1

	If IsArray($sourceArray) And $sourceArray[0][1] > 0 Then
		For $i = 1 To UBound($sourceArray) - 1
			$coordsArray = $sourceArray[$i][5]

			For $j = 0 To UBound($coordsArray) - 1
				$side = calculateSideFromXY($coordsArray[$j][0], $coordsArray[$j][1])

				If $side <> -1 Then $pointsTotal[$side] += Number($pointValue)
			Next
		Next

		If $debugSetLog = 1 Then SetLog("Calculated Points: " & $pointsTotal[0] & ", " & $pointsTotal[1] & ", " & $pointsTotal[2] & ", " & $pointsTotal[3])
	EndIf
EndFunc   ;==>calculateStoragePoints

; Calculate points for the entries in the array and assign them to a side
Func calculatePoints(ByRef $pointsTotal, $sourceArray, $pointValue)
	Local $coords, $side = -1

	If IsArray($sourceArray) Then
		For $i = 0 To UBound($sourceArray) - 1
			$coords = $sourceArray[$i]

			If UBound($coords) = 2 Then
				$side = calculateSideFromXY($coords[0], $coords[1])
			Else
				$side = -1
			EndIf

			If $side <> -1 Then $pointsTotal[$side] += Number($pointValue)
		Next

		If $debugSetLog = 1 Then SetLog("Calculated Points: " & $pointsTotal[0] & ", " & $pointsTotal[1] & ", " & $pointsTotal[2] & ", " & $pointsTotal[3])
	EndIf
EndFunc   ;==>calculatePoints

; Calculate which side to attack from, based on values in the UI for buildings
Func calculateAttackSide(ByRef $aMines, ByRef $aElixir, ByRef $aDrills, ByRef $aGoldStorage, ByRef $aElixirStorage, ByRef $aDEStorage, ByRef $aTownHall)
	Local $aSideCount[4] = [0, 0, 0, 0]
	Local $redlines = "", $result

	; Start the timer for drop point creation
	Local $hTimer = TimerInit()	

	; Capture the screen to get information about important buildings
	_CaptureRegion2()

	SetLog("Calculating side to attack from, please be patient...", $COLOR_BLUE)
	SetLog("This can take some time, don't panic if the battle timer starts!", $COLOR_BLUE)

	$aTownHall = getArrayInDiamond(GetLocationTownHall())
	calculatePoints($aSideCount, $aTownHall, Number($valueTownHall))

	If Not getGoldStorageFull() Then
		; Only Collect the Mine information if the Mines are worth points
		If Number($valueGoldMine) > 0 Then $aMines = getArrayInDiamond(GetLocationMine())
		; Skip the storage calculation for now, the images are not accurate
		; Only Collect the Gold Storage information if the Gold Storage are worth points
		; If Number($valueGoldStorage) > 0 Then $aGoldStorage = getArrayInDiamond(GetLocationGoldStorage())
		calculatePoints($aSideCount, $aMines, Number($valueGoldMine))
		; calculateStoragePoints($aSideCount, $aGoldStorage, Number($valueGoldStorage))
	Else
		SetLog("Gold full, skipping detection of gold mines and storages!", $COLOR_BLUE)
	EndIf
	If IsArray($aGoldStorage) And UBound($aGoldStorage) >= 1 Then $redlines = $aGoldStorage[0][0]

	If Not getElixirStorageFull() Then
		; Only Collect the Elixir Collector information if the Elixir Collectors are worth points
		If Number($valueElixirCollector) > 0 Then $aElixir = getArrayInDiamond(GetLocationElixir())
		; Skip the storage calculation for now, the images are not accurate
		; Only Collect the Elixir Storage information if the Elixir Storage are worth points
		; If Number($valueElixirStorage) > 0 Then $aElixirStorage = getArrayInDiamond(GetLocationElixirStorage())
		calculatePoints($aSideCount, $aElixir, Number($valueElixirCollector))
		; calculateStoragePoints($aSideCount, $aElixirStorage, Number($valueElixirStorage))
	Else
		SetLog("Elixir full, skipping detection of elixir collectors and storages!", $COLOR_BLUE)
	EndIf

	; Only calculate points for DE structures if you can store DE
	If $iTownHallLevel >= 7 And Not getDarkElixirStorageFull() Then
		; Only Collect the Drill information if the Drills are worth points
		If Number($valueDEDrill) > 0 Then $aDrills = getArrayInDiamond(GetLocationDarkElixir())
		; Always get DE Storage information if you can collect DE as its used for spell target as well
		$aDEStorage = getArrayInDiamond(GetLocationDarkElixirStorage())
		calculatePoints($aSideCount, $aDrills, Number($valueDEDrill))
		calculatePoints($aSideCount, $aDEStorage, Number($valueDEStorage))
	Else
		SetLog("Dark Elixir full, skipping detection of drills and storage!", $COLOR_BLUE)
	EndIf

	$result = determineSideFromPoints($aSideCount)

	SetLog("Attacking using a custom deployment on the " & getSideName($result) & " side.", $COLOR_BLUE)
	SetLog("Deployment side calculated in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds!", $COLOR_PURPLE)	
	Return $result
EndFunc   ;==>calculateAttackSide

; Gets the location of the priority target for use with spells
; Must be called after getAttackSide so that it has a target building locations
Func getSpellTargetLocation(ByRef $aDEStorage, ByRef $aTownHall)
	; Set the return to the screen center by default
	Local $result[3] = ["Center", $centerX, $centerY]
	Local $aCoords

	If $iTownHallLevel >= 7 And IsArray($aDEStorage) And Not getDarkElixirStorageFull() Then
		$aCoords = $aDEStorage[0]

		$result[0] = "DE Storage" ; Building Type
		$result[1] = $aCoords[0] ; X Coord
		$result[2] = $aCoords[1] ; Y Coord
	ElseIf IsArray($aTownHall) Then
		$aCoords = $aTownHall[0]

		$result[0] = "Town Hall" ; Building Type
		$result[1] = $aCoords[0] ; X Coord
		$result[2] = $aCoords[1] ; Y Coord
	EndIf

	SetLog("Target for spells is the " & $result[0] & " located at " & $result[1] & "," & $result[2], $COLOR_BLUE)
	Return $result
EndFunc   ;==>getSpellTargetLocation

; Deploys the troops for the specified wave
Func customDeployTroops($dropVectors, $waveNumber, $barPosition, $dropAmount, $position = 0)
	If $dropAmount = 0 Or isProblemAffect(True) Then Return False

	If $position = 0 Or $dropAmount < $position Then $position = $dropAmount

	Local $troopsLeft = $dropAmount
	Local $troopsPerSlot = 0

	If _SleepAttack($iDelayLaunchTroop21) Then Return
	SelectDropTroop($barPosition) ; Select Troop
	If _SleepAttack($iDelayLaunchTroop23) Then Return

	For $i = 0 To $position - 1
		$troopsPerSlot = Ceiling($troopsLeft / ($position - $i)) ; progressively adapt the number of drops to fill at the best

		standardSideDrop($dropVectors, $waveNumber, 0, $i, $troopsPerSlot, True)

		$troopsLeft -= ($troopsLeft < $troopsPerSlot) ? $troopsLeft : $troopsPerSlot
	Next
	
	Return True
EndFunc   ;==>customDeployTroops

; Main function for processing Custom Deploy attack
Func launchCustomDeploy($listInfoDeploy, $CC, $King, $Queen, $Warden)
	; Arrays to store positions of all important buildings, used for calculating attack side
	Local $aMines, $aElixir, $aDrills, $aGoldStorage, $aElixirStorage, $aDEStorage, $aTownHall
	Local $dropVectors[0][0]

	Local $side = calculateAttackSide($aMines, $aElixir, $aDrills, $aGoldStorage, $aElixirStorage, $aDEStorage, $aTownHall)
	Local $deploySide = getSideCoords($side)
	Local $spellTarget = getSpellTargetLocation($aDEStorage, $aTownHall)

	; Setup the attack vectors for the troops
	customDeployVectors($dropVectors, $listInfoDeploy, $side)

	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves
	Local $dropPoints, $dropPoint, $deployPoint, $dropAmount, $positionSide

	If $debugSetLog = 1 Then SetLog("Launch Custom Deploy with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()
	Local $barPosition = -1

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1

		If $kind = $eDeployWait Then
			If $position > 0 Then
				SetLog("Waiting for " & $position & " seconds.", $COLOR_BLUE)
				If _SleepAttack(1000 * $position) Then Return
			EndIf
		ElseIf $kind <= $eHaSpell Then
			$barPosition = $aDeployButtonPositions[$kind]

			If $barPosition <> -1 Then
				$positionSide = StringUpper(StringRight($position, 1))
				$position = Number($position)
				
				Switch $kind
					Case $eKing To $eCastle
						$dropPoints = $dropVectors[$i][0]						
						Switch $positionSide
							Case "L"
								$deployPoint = $dropPoints[0]
							Case "R"
								$deployPoint = $dropPoints[UBound($dropPoints) - 1]
							Case Else
								$deployPoint = $dropPoints[Random(0, UBound($dropPoints) - 1, 1)]
						EndSwitch

						If IsArray($deployPoint) And UBound($deployPoint) >=2 Then
							Switch $kind
								Case $eKing
									dropHeroes($deployPoint[0], $deployPoint[1], $King, -1, -1)
								Case $eQueen
									dropHeroes($deployPoint[0], $deployPoint[1], -1, $Queen, -1)
								Case $eWarden
									dropHeroes($deployPoint[0], $deployPoint[1], -1, -1, $Warden)
								Case $eCastle
									dropCC($deployPoint[0], $deployPoint[1], $CC)
							EndSwitch
						EndIf
					Case Else
						Switch $positionSide
							Case "L"
								$deployPoint = convertToPoint($deploySide[0][0], $deploySide[0][1])
							Case "R"
								$deployPoint = convertToPoint($deploySide[4][0], $deploySide[4][1])
							Case Else
								$deployPoint = convertToPoint($deploySide[2][0], $deploySide[2][1])
						EndSwitch
						
						Switch $kind
							Case $eLSpell To $eHaSpell
								If ($kind <> $eESpell) Or ($kind = $eESpell And $King <> -1) Then
									; Drop spell towards the target or center if no target
									$dropPoint = convertToPoint(Ceiling((((100 - $position) * $deployPoint[0]) + ($position * $spellTarget[1])) / 100), Ceiling((((100 - $position) * $deployPoint[1]) + ($position * $spellTarget[2])) / 100))
									dropSpell($dropPoint, $kind, $minTroopsPerPosition[$kind])

									If $unitCount[$kind] >= $minTroopsPerPosition[$kind] Then $unitCount[$kind] -= $minTroopsPerPosition[$kind]
								ElseIf $kind = $eESpell And $King = -1 Then
									SetLog("Saving earthquake for when the king is present", $COLOR_BLUE)
								EndIf
							Case Else
								$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position, $minTroopsPerPosition[$kind])
								$unitCount[$kind] -= $dropAmount

								If $dropAmount > 0 Then
									Switch $positionSide
										Case "L", "R"
											If IsArray($deployPoint) And UBound($deployPoint) >=2 Then
												SetLog("Dropping " & $dropAmount & " " & getTranslatedTroopName($kind) & " at random location near " & $deployPoint[0] & "," & $deployPoint[1], $COLOR_BLUE)
												If dropUnit($deployPoint, $kind, $dropAmount) Then
													If _SleepAttack(SetSleep(1)) Then Return
												EndIf
											EndIf
										Case Else
											SetLog("Dropping " & getWaveName($waveNumber, $waveCount) & " wave of " & $dropAmount & " " & getTranslatedTroopName($kind), $COLOR_GREEN)

											If customDeployTroops($dropVectors, $i, $barPosition, $dropAmount, $position) Then
												If _SleepAttack(SetSleep(1)) Then Return
											EndIf
									EndSwitch
								EndIf
						EndSwitch
				EndSwitch
			EndIf
		EndIf
	Next

	If _SleepAttack($iDelayalgorithm_AllTroops4) Then Return

	dropRemainingTroopsCustom($side) ; Use remaining troops
	useHeroesAbility() ; Use heroes abilities

	SetLog("Finished Attacking, waiting for the battle to end")
	Return True
EndFunc   ;==>launchCustomDeploy