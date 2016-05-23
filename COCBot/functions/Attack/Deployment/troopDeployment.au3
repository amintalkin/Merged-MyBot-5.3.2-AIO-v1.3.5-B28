; #CLASS# ====================================================================================================================
; Name ..........: troopDeployment
; Description ...: Contains various utility functions used for troop deployments
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Convert X,Y coords to a point array
Func convertToPoint($x = 0, $y = 0)
	Local $aResult[2] = [0, 0]

	$aResult[0] = $x
	$aResult[1] = $y

	Return $aResult
EndFunc   ;==>convertToPoint

; Moves a point a set number of pixels in a direction based on its side
Func movePointBasedOnSide($dropPoint, $deltaX, $deltaY)
	Local $result[2] = [-1, -1]
	
	If Not IsArray($dropPoint) Then Return $result ; Exit for safety

	Switch calculateSideFromXY($dropPoint[0], $dropPoint[1])
		Case $sideTopLeft
			$result[0] = $dropPoint[0] - $deltaX
			$result[1] = $dropPoint[1] - $deltaY
		Case $sideTopRight
			$result[0] = $dropPoint[0] + $deltaX
			$result[1] = $dropPoint[1] - $deltaY
		Case $sideBottomRight
			$result[0] = $dropPoint[0] + $deltaX
			$result[1] = $dropPoint[1] + $deltaY
		Case $sideBottomLeft
			$result[0] = $dropPoint[0] - $deltaX
			$result[1] = $dropPoint[1] + $deltaY
		Case Else
			; Should never get here unless there is something wrong with the code
			$result[0] = -1
			$result[1] = -1			
	EndSwitch
	
	Return $result
EndFunc   ;==>movePointBasedOnSide

; Adds randomness to attack clicks for safety
Func randomAttackClick($dropPoint, $numClicks = 1, $clickSpeed = 0, $delayAfter = 0, $debugText = "", $deltaX = 0, $deltaY = 0)
	If Not IsArray($dropPoint) Then Return ; Exit for safety

	Local $randomDropPoint[2] = [0, 0]

	If $debugSetLog = 1 Then SetLog("Randomized Click Coordinate (x,y): " & $dropPoint[0] & "," & $dropPoint[1])
	
	For $i = 0 To $numClicks - 1
		$randomDropPoint = movePointBasedOnSide($dropPoint, Random(0, $deltaX, 1), Random(0, $deltaY, 1))
		; Calculate which quadrant the click is in and adjust randomness accordingly

		If isInsideDiamond($randomDropPoint) Then
			AttackClick($randomDropPoint[0], $randomDropPoint[1], 1, $clickSpeed, $delayAfter, $debugText)
		Else
			AttackClick($dropPoint[0], $dropPoint[1], 1, $clickSpeed, $delayAfter, $debugText)
		EndIf
	Next
EndFunc   ;==>randomAttackClick

; Calculate drop lines for sides based on Redline data
Func calculateRedLine()
	; Capture the screen and get redline data
	_CaptureRegion2()
	_GetRedArea()
	
	; Clean redline points
	CleanRedArea($PixelTopLeft)
	CleanRedArea($PixelTopRight)
	CleanRedArea($PixelBottomRight)
	CleanRedArea($PixelBottomLeft)
EndFunc   ;==>calculateRedLine

; Gets redline drop points for the specified side
Func getSideDropLine($side)
	Local $result
	
	If $side < $sideBottomRight Or $side > $sideTopRight Then $side = Random($sideBottomRight, $sideTopRight, 1)
		
	Switch $side
		Case $sideTopLeft
			$result = $PixelTopLeft
		Case $sideTopRight
			$result = $PixelTopRight
		Case $sideBottomRight
			$result = $PixelBottomRight
		Case $sideBottomLeft
			$result = $PixelBottomLeft
		Case Else
			; Should not get here unless there is a problem with the code
	EndSwitch
	
	Return $result
EndFunc   ;==>getSideDropLine

; Not used, redline data is not accurate enough and the point can end up inside a red area
Func getTroopOffset($kind)
	Local $result = 0
	
	Switch $kind
		; Tank units, only offset 1 tile
		Case $eGiant, $eGole, $eLava
			$result = 1
		; Melee dps units, offset 2 tiles
		Case $eBarb, $ePekk, $eHogs, $eValk, $eKing
			$result = 2
		; All other units, offset 3 tiles
		Case Else
			$result = 3
	EndSwitch

	Return $result
EndFunc   ;==>getTroopOffset

; Create a series of drop points for troops
Func addVector(ByRef $vectorArray, $waveNumber, $sideNumber, $side, $direction, $addTiles, $dropPoints)
	If Not IsArray($vectorArray) Then Return ; Exit for safety

	Local $aDropPoints[$dropPoints], $aDropPoint[2], $indexCounter = 0, $loopCounter = 0
	
	; Get the redline data for the side
	Local $redlines = getSideDropLine($side)
	; Modify drop points because for 1 or 2 drop points, we wish to ignore the two end points
	Local $modifiedDropPoints = ($dropPoints > 2) ? ($dropPoints - 1) : ($dropPoints + 1)
	; Calculate the number of differnce in indexes between each point
	Local $stepRight = ((UBound($redlines) - 1) / $modifiedDropPoints > 0) ? ((UBound($redlines) - 1) / $modifiedDropPoints) : 1
	; Convert it to a negative number because we need to decrease index when deploying to the left
	Local $stepLeft = 0 - $stepRight
	
	Switch $direction
		Case $directionLeft
			; Loop throught the array from the end to the start
			For $i = UBound($redlines) To 1 Step $stepLeft
				; Get the current point in the redline array, round $i because index has to be a whole number
				$aDropPoint = $redlines[Round($i) - 1]

				; Loop through points starting at the max add tiles distance until we get a valid point
				For $pixelMove = 8 * Abs(Int($addtiles)) To 0 Step -1
					; Get the new point
					$movedDropPoint = movePointBasedOnSide($aDropPoint, $pixelMove, $pixelMove)

					; Check to make sure its a valid point
					If isInsideDiamondRedArea($movedDropPoint) Then ExitLoop
				Next

				; Store the point when necessary, skips storing the end points if there is only 1 or 2 points
				If $indexCounter < UBound($aDropPoints) And ($dropPoints > 2 Or ($dropPoints <= 2 And $loopCounter > 0)) Then
					; Store the point and increase the counter
					$aDropPoints[$indexCounter] = $movedDropPoint
					$indexCounter += 1
				EndIf
				
				; Increase the loop counter
				$loopCounter += 1
			Next
		Case $directionRight
			; Loop throught the array from the beginning to the end
			For $i = 1 To UBound($redlines) Step $stepRight
				; Get the current point in the redline array, round $i because index has to be a whole number
				$aDropPoint = $redlines[Round($i) - 1]

				; Loop through points starting at the max add tiles distance until we get a valid point
				For $pixelMove = 8 * Abs(Int($addtiles)) To 0 Step -1
					; Get the new point
					$movedDropPoint = movePointBasedOnSide($aDropPoint, $pixelMove, $pixelMove)

					; Check to make sure its a valid point
					If isInsideDiamondRedArea($movedDropPoint) Then ExitLoop
				Next

				; Store the point when necessary, skips storing the end points if there is only 1 or 2 points
				If $indexCounter < UBound($aDropPoints) And ($dropPoints > 2 Or ($dropPoints <= 2 And $loopCounter > 0)) Then
					; Store the point and increase the counter
					$aDropPoints[$indexCounter] = $movedDropPoint
					$indexCounter += 1
				EndIf

				; Increase the loop counter
				$loopCounter += 1
			Next			
		Case Else
			; Should not get here unless there is a problem with the code			
	EndSwitch

	; Store the drop data in the array, it was passed ByRef, so it changes the variable in the calling function
	$vectorArray[$waveNumber][$sideNumber] = $aDropPoints
EndFunc   ;==>addVector

; Drop the number of spells specified on the specified location, will use clan castle spells if you have it.
Func dropSpell($dropPoint, $spell = -1, $number = 1)
	If Not IsArray($dropPoint) Or $spell = -1 Then Return False ; Exit for safety

	Local $result = False
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $barPosition = $aDeployButtonPositions[$spell]
	Local $barCCSpell = $aDeployButtonPositions[$eCCSpell]
	Local $spellCount = unitCount($spell)
	Local $ccSpellCount = unitCount($eCCSpell)
	Local $totalSpells = $spellCount + $ccSpellCount

	If $totalSpells < $number Then
		SetLog("Only " & $totalSpells & " " & getTranslatedTroopName($spell) & " available.  Waiting for " & $number & ".")
		Return $result
	EndIf

	; Check to see if we have a spell in the CC and it hasn't be used
	If $barCCSpell <> -1 And getCCSpellType() = $spell And $totalSpells >= $number Then
		If _SleepAttack(100) Then Return

		If _SleepAttack($iDelayLaunchTroop21) Then Return
		SelectDropTroop($barCCSpell) ; Select Clan Castle Spell
		If _SleepAttack($iDelayLaunchTroop23) Then Return

		SetLog("Dropping " & getTranslatedTroopName($spell) & " in the Clan Castle" & " on button " & ($barCCSpell + 1) & " at " & $x & "," & $y, $COLOR_BLUE)
		randomAttackClick($dropPoint, $ccSpellCount, 100, 0, "")
		$number -= $ccSpellCount

		If $barPosition <> -1 And $number > 0 And $spellCount >= $number Then ; Need to use standard spells as well as clan castle spell.
			If _SleepAttack(100) Then Return
			If $debugSetlog = 1 Then SetLog("Dropping " & getTranslatedTroopName($spell) & " in slot " & $barPosition, $COLOR_BLUE)

			If _SleepAttack($iDelayLaunchTroop21) Then Return
			SelectDropTroop($barPosition) ; Select Spell
			If _SleepAttack($iDelayLaunchTroop23) Then Return

			SetLog("Dropping " & $number & " " & getTranslatedTroopName($spell) & " on button " & ($barPosition + 1) & " at " & $x & "," & $y, $COLOR_BLUE)
			randomAttackClick($dropPoint, $number, 100, 0, "")
		EndIf

		$result = True
	ElseIf $barPosition <> -1 And $spellCount >= $number Then ; Check to see if we have a spell trained
		If _SleepAttack(100) Then Return

		SelectDropTroop($barPosition) ; Select Spell
		SetLog("Dropping " & $number & " " & getTranslatedTroopName($spell) & " on button " & ($barPosition + 1) & " at " & $x & "," & $y, $COLOR_BLUE)
		randomAttackClick($dropPoint, $number, 100, 0, "")

		$result = True
	EndIf

	Return $result
EndFunc   ;==>dropSpell

; Drop the number of units specified on the specified location, even allows for random variation if specified.
Func dropUnit($dropPoint, $unit = -1, $number = 1)
	If Not IsArray($dropPoint) Or $unit = -1 Then Return False ; Exit for safety

	Local $result = False
	Local $barPosition = unitLocation($unit)
	Local $unitCount = unitCount($unit)

	If $barPosition <> -1 And $unitCount >= $number Then ; Check to see if we have any units to drop
		If _SleepAttack(100) Then Return
		If $unitCount < $number Then $number = $unitCount

		If _SleepAttack($iDelayLaunchTroop21) Then Return
		SelectDropTroop($barPosition) ; Select Troop
		If _SleepAttack($iDelayLaunchTroop23) Then Return

		SetLog("Dropping " & $number & " " & getTranslatedTroopName($unit) & " at " & $x & "," & $y, $COLOR_BLUE)
		randomAttackClick($dropPoint, $number, SetSleep(0), 0)

		$result = True
	EndIf

	Return $result
EndFunc   ;==>dropUnit

; Drop the troops in a standard drop along a vector
Func standardSideDrop($dropVectors, $waveNumber, $sideNumber, $currentSlot, $troopsPerSlot, $useDelay = False)
	If Not IsArray($dropVectors) Then Return
	
	Local $delay = ($useDelay = True) ? SetSleep(0) : 0
	Local $dropPoints = $dropVectors[$waveNumber][$sideNumber]

	If $currentSlot < UBound($dropPoints) Then randomAttackClick($dropPoints[$currentSlot], $troopsPerSlot, $delay, 0, "")
EndFunc   ;==>standardSideDrop

; Drop the troops in a standard drop from two points along vectors at once
Func standardSideTwoFingerDrop($dropVectors, $waveNumber, $sideNumber, $currentSlot, $troopsPerSlot, $useDelay = False)
	If Not IsArray($dropVectors) Then Return
	
	standardSideDrop($dropVectors, $waveNumber, $sideNumber, $currentSlot, $troopsPerSlot)
	standardSideDrop($dropVectors, $waveNumber, $sideNumber + 1, $currentSlot + 1, $troopsPerSlot, $useDelay)
EndFunc   ;==>twoFingerStandardSideDrop
