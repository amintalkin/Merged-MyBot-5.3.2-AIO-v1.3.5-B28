; #CLASS# ====================================================================================================================
; Name ..........: saveTroopsForCollectors
; Description ...: Contains functions for save troops for collector deployment
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Display any relevant log entries
Func saveTroopsDisplayLog($numMines = 0, $numElixir = 0, $numDrills = 0, $totalCollectors = 0, $exposedCollectors = 0)
	; Display information about found collectors
	If $numMines > 0 Then SetLog("Found " & $numMines & " Gold Mines", $COLOR_BLUE)
	If $numElixir > 0 Then SetLog("Found " & $numElixir & " Elixir Collectors", $COLOR_BLUE)
	If $numDrills > 0 Then SetLog("Found " & $numDrills & " Dark Elixir Drills", $COLOR_BLUE)
	If $totalCollectors > 0 Then SetLog("Total Collectors: " & $totalCollectors, $COLOR_BLUE)
	If $exposedCollectors > 0 Then SetLog("Total Exposed Collectors: " & $exposedCollectors, $COLOR_BLUE)
EndFunc  ;==>saveTroopsDisplayLog

; Updates the stats tab
Func saveTroopsUpdateStats($numMines = 0, $numElixir = 0, $numDrills = 0)
	; Update Stats
	$iNbrOfDetectedMines[$DB] += $numMines
	$iNbrOfDetectedCollectors[$DB] += $numElixir
	$iNbrOfDetectedDrills[$DB] += $numDrills

	UpdateStats()
EndFunc  ;==>saveTroopsUpdateStats

; Get the array of elixir collector locations, only if needed
Func calculateElixirCollectors(ByRef $aElixir)
	; Setup return value
	Local $return = 0

	; Check to see if able to store elixir
	If Number($iChkSmartAttack[$DB][1]) = 1 And Not getElixirStorageFull() Then
		; It's not full so get the array of elixir collectors
		$aElixir = getArrayInDiamond(GetLocationElixir())
		; Get a count of the number of elixir collectors found
		$return = UBound($aElixir)
	Else
		SetLog("Skipping detection of elixir collectors!", $COLOR_BLUE)
	EndIf

	Return $return
EndFunc  ;==>calculateElixirCollectors

; Get the array of mine locations, only if needed
Func calculateDrills(ByRef $aDrills)
	; Setup return value
	Local $return = 0

	; Check to see if able to store Dark Elixir
	If Number($iChkSmartAttack[$DB][2]) = 1 And $iTownHallLevel >= 7 And Not getDarkElixirStorageFull() Then
		; It's not full, and player is high enough to collect DE so get the array of drills
		$aDrills = getArrayInDiamond(GetLocationDarkElixir())
		; Get a count of the number of drills found
		$return = UBound($aDrills)
	Else
		SetLog("Skipping detection of dark elixir drills!", $COLOR_BLUE)
	EndIf

	Return $return
EndFunc  ;==>calculateDrills

; Get the array of mine locations, only if needed
Func calculateMines(ByRef $aMines)
	; Setup return value
	Local $return = 0

	; Check to see if able to store gold
	If Number($iChkSmartAttack[$DB][0]) = 1 And Not getGoldStorageFull() Then
		; It's not full so get the array of mines
		$aMines = getArrayInDiamond(GetLocationMine())
		; Get a count of the number of mines found
		$return = UBound($aMines)
	Else
		SetLog("Skipping detection of gold mines!", $COLOR_BLUE)
	EndIf

	Return $return
EndFunc  ;==>calculateMines

; Calculate how many troops to drop for the wave
Func calculateSaveTroopsDropAmount($unitCount, $collectors = 0, $maxTroopsPerCollector = 0, $remainingWaves = 1)
	; Setup an empty return value
	Local $return = 0

	; Calculate how many troops you can drop, devided by the remaining waves
	Local $troopsPerCollector = Ceiling(($unitCount / $collectors) / $remainingWaves)

	; Return the calculated amount you can drop, or the max you can drop, whichever is lowest
	$return = _Min($troopsPerCollector, $maxTroopsPerCollector)

	Return $return
EndFunc  ;==>calculateSaveTroopsDropAmount

; Generate an array of closest drop points for collectors within 50 pixels of the red line
; This is used for deploying giants as a distraction
Func getCloserDropPoints($location)
	If IsArray($PixelRedArea) = False Then Return ; Prevent error

	Local $aPixelCloser[2] = [-1, -1]
	Local $closestDistance = 0, $distance = 0
	Local $aPixel

	For $i = 0 To UBound($PixelRedArea) - 1
		$aPixel = $PixelRedArea[$i]
		$distance = calculateDistanceBetweenPoints($aPixel, $location)

		If $distance <= Number($redlineDistance) And ($closestDistance = 0 Or $distance < $closestDistance) Then
			$closestDistance = $distance
			$aPixelCloser = $aPixel
		EndIf
	Next

	Return $aPixelCloser
EndFunc   ;==>getCloserDropPoints

; Generate an array of drop points for collectors within 50 pixels of the red line
; This is used for deploying the cleanup troops
Func getDropPoints($location)
	If IsArray($PixelRedAreaFurther) = False Then Return ; Prevent error

	Local $aPixelCloser[2] = [-1, -1]
	Local $closestDistance = 0, $distance = 0
	Local $aPixel

	For $i = 0 To UBound($PixelRedAreaFurther) - 1
		$aPixel = $PixelRedAreaFurther[$i]
		$distance = calculateDistanceBetweenPoints($aPixel, $location)

		If $closestDistance = 0 Or $distance < $closestDistance Then
			$closestDistance = $distance
			$aPixelCloser = $aPixel
		EndIf
	Next

	Return $aPixelCloser
EndFunc   ;==>getDropPoints

; Update drop points for the passed collector array
; The drop point arrays are passed ByRef so this function can edit the local $arrays in the calling function
Func getArrayDropPoints($aCollectors, ByRef $collectorDropPoints, ByRef $collectorDropPointsCloser)
	If Not IsArray($aCollectors) Then Return ; Prevent error

	Local $collectorLocation, $dropLocation

	For $i = 0 To UBound($aCollectors) - 1
		$collectorLocation = $aCollectors[$i]
		$dropLocation = getCloserDropPoints($collectorLocation)

		If $dropLocation[0] <> -1 And $dropLocation[1] <> -1 Then
			ReDim $collectorDropPoints[UBound($collectorDropPoints) + 1]
			ReDim $collectorDropPointsCloser[UBound($collectorDropPointsCloser) + 1]

			$collectorDropPointsCloser[UBound($collectorDropPointsCloser) - 1] = $dropLocation
			$collectorDropPoints[UBound($collectorDropPoints) - 1] = getDropPoints($collectorLocation)
		EndIf
	Next
EndFunc   ;==>getArrayDropPoints

; Perform all the calculations necessary to determine collectors to attack and where to drop troops
Func calculateOverallCollectorInfo(ByRef $collectorDropPoints, ByRef $collectorDropPointsCloser, ByRef $aMines, ByRef $aElixir, ByRef $aDrills, ByRef $numMines, ByRef $numElixir, ByRef $numDrills, ByRef $totalCollectors, ByRef $exposedCollectors)
	; Capture screen to get collector information to determine what we should do
	_CaptureRegion2()

	; Get information about collectors where required
	$numMines = calculateMines($aMines)
	$numElixir = calculateElixirCollectors($aElixir)
	$numDrills = calculateDrills($aDrills)
	$totalCollectors = $numMines + $numElixir + $numDrills

	; Update the stats tab
	saveTroopsUpdateStats($numMines, $numElixir, $numDrills)

	; Fill the red line drop points for the collectors left
	getArrayDropPoints($aDrills, $collectorDropPoints, $collectorDropPointsCloser)
	getArrayDropPoints($aElixir, $collectorDropPoints, $collectorDropPointsCloser)
	getArrayDropPoints($aMines, $collectorDropPoints, $collectorDropPointsCloser)

	$exposedCollectors = UBound($collectorDropPoints)
	; Display information about found collectors
	saveTroopsDisplayLog($numMines, $numElixir, $numDrills, $totalCollectors, $exposedCollectors)
EndFunc   ;==>calculateOverallCollectorInfo

; Main function for processing Save Troops for Collectors attack
Func launchSaveTroopsForCollectors($listInfoDeploy, $CC, $King, $Queen, $Warden)
	Local $collectorDropPoints[0], $collectorDropPointsCloser[0], $dropPoint, $lastDropPoint[2] = [0, 0]

	Local $kind, $nbSides, $waveNumber, $waveCount, $position, $dropAmount
	Local $aMines, $aElixir, $aDrills
	Local $numMines = 0, $numElixir = 0, $numDrills = 0, $totalCollectors = 0, $exposedCollectors = 0

	Local $barPosition = -1

	If $debugSetlog = 1 Then SetLog("Launch Save Troops for Collectors with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden, $COLOR_PURPLE)

	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	SetLog("Locating Mines, Collectors & Drills", $COLOR_BLUE)
	SetLog("This can take some time, don't panic if the battle timer starts!", $COLOR_BLUE)
	; Perform all calculations necessary to determine which collectors to attack and drop points
	calculateOverallCollectorInfo($collectorDropPoints, $collectorDropPointsCloser, $aMines, $aElixir, $aDrills, $numMines, $numElixir, $numDrills, $totalCollectors, $exposedCollectors)

	If ($exposedCollectors / $totalCollectors) * 100 < $percentCollectors Then
		If $useAllSides = 1 Then
			SetLog("There are less than " & $percentCollectors & "% collectors near the RED LINE!", $COLOR_BLUE)
			SetLog("Change the Attack Strategy to All Sides...", $COLOR_BLUE)

			If _SleepAttack(500) Then Return

			; Change settings needed for all sides mode
			$nbSides = 4
			$usingAllSides = True

			; Change to the All Sides List Deploy
			Local $allSidesDeploy = getDeploymentInfo($nbSides, $eAllSides)
			launchStandard($allSidesDeploy, $CC, $King, $Queen, $Warden, 4)

			Return True
		Else
			SetLog("There are less than " & $percentCollectors & "% collectors near the RED LINE!", $COLOR_BLUE)
			SetLog("Ending the battle so troops are not wasted...", $COLOR_BLUE)
			CloseBattle(True)
		EndIf
	Else
		SetLog("Attacking with save troops for collectors.", $COLOR_BLUE)
		While IsAttackPage() And $exposedCollectors > 0 And $unitCount[$eBarb] + $unitCount[$eArch] + $unitCount[$eWiza] + $unitCount[$eMini] + $unitCount[$eGobl] > 0
			For $j = 0 To UBound($collectorDropPoints) - 1
				For $i = 0 To UBound($listInfoDeploy) - 1
					$kind = $listInfoDeploy[$i][0]
					$nbSides = $listInfoDeploy[$i][1]
					$waveNumber = $listInfoDeploy[$i][2]
					$waveCount = $listInfoDeploy[$i][3]
					$position = $listInfoDeploy[$i][4]
					$barPosition = $aDeployButtonPositions[$kind]

					If $barPosition <> -1 Then
						If $debugSetlog = 1 Then SetLog("**ListInfoDeploy row " & $i & ": USE " & $kind & " SIDES " & $nbSides & " WAVE " & $waveNumber & " XWAVE " & $waveCount & " SLOTXEDGE " & $position, $COLOR_PURPLE)

						$dropAmount = calculateSaveTroopsDropAmount($unitCount[$kind], UBound($collectorDropPoints), $maxSaveTroopsPerCollector[$kind])

						If $dropAmount > 0 And $dropAmount <= $unitCount[$kind] Then
							Switch $kind
								Case $eBarb, $eArch, $eWiza, $eMini, $eGobl
									; Drop these unit types further away
									$dropPoint = $collectorDropPoints[$j]

									SetLog("Dropping " & $dropAmount & " " & getTranslatedTroopName($kind) & " at random location near " & $dropPoint[0] & "," & $dropPoint[1], $COLOR_BLUE)
									If dropUnit($dropPoint, $kind, $dropAmount) Then
										If _SleepAttack(SetSleep(1)) Then Return
									EndIf

									$unitCount[$kind] -= ($unitCount[$kind] < $dropAmount) ? $unitCount[$kind] : $dropAmount
								Case $eGiant
									; Drop giants closer as a distraction
									$dropPoint = $collectorDropPointsCloser[$j]

									; Make sure there is enough distance between the drop point and the last dropped giant so they are not wasted
									If calculateDistanceBetweenPoints($dropPoint, $lastDropPoint) >= 75 Then
										$lastDropPoint[0] = $dropPoint[0]
										$lastDropPoint[1] = $dropPoint[1]

										SetLog("Dropping " & $dropAmount & " " & getTranslatedTroopName($kind) & " at random location near " & $dropPoint[0] & "," & $dropPoint[1], $COLOR_BLUE)
										If dropUnit($dropPoint, $kind, $dropAmount) Then
											If _SleepAttack(SetSleep(1)) Then Return
										EndIf

										$unitCount[$kind] -= ($unitCount[$kind] < $dropAmount) ? $unitCount[$kind] : $dropAmount
									EndIf
								Case Else
									; We are not interested in other troop types, so we are doing nothing here
							EndSwitch
						EndIf
					EndIf
				Next
			Next

			SetLog("Waiting for 20 seconds, to see if the collectors are destroyed.", $COLOR_BLUE)
			If _SleepAttack(20 * 1000) Then Return

			; Make sure we are still able to attack
			If IsAttackPage() Then
				; Reset the drop point arrays
				Dim $collectorDropPoints[0]
				Dim $collectorDropPointsCloser[0]

				; Reset the collector location arrays
				Dim $aDrills[0]
				Dim $aElixir[0]
				Dim $aMines[0]

				; Recapture Collector Information to determine if we should continue
				Setlog("Checking for remaining collectors...", $COLOR_BLUE)
				; Perform all calculations necessary to determine which collectors to attack and drop points
				calculateOverallCollectorInfo($collectorDropPoints, $collectorDropPointsCloser, $aMines, $aElixir, $aDrills, $numMines, $numElixir, $numDrills, $totalCollectors, $exposedCollectors)

				; Display the appropriate log entries
				If $exposedCollectors > 0 Then
					If $unitCount[$eBarb] + $unitCount[$eArch] + $unitCount[$eWiza] + $unitCount[$eMini] + $unitCount[$eGobl] > 0 Then
						SetLog("Continue attacking...", $COLOR_BLUE)
					Else
						SetLog("No collector attack troops remaining, so lets just exit...", $COLOR_BLUE)
						ExitLoop
					EndIf
				Else
					SetLog("There are no exposed collectors left, so lets just exit...", $COLOR_BLUE)
					ExitLoop
				EndIf
			Else
				ExitLoop
			EndIf
		WEnd
	EndIf

	CloseBattle(True)
	Return True
EndFunc   ;==>launchSaveTroopsForCollectors