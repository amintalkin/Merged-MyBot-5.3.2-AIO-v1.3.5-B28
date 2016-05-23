; #CLASS# ====================================================================================================================
; Name ..........: attackFunctions
; Description ...: Contains misc functions used by attack profiles, and other attack functions
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

; Returns whether the DE Storage is full when in battle
Func getDarkElixirStorageFull()
	Local $return = False
	Local $aDarkElixirStorageFull[4] = [743, 94, 0x1A0026, 10] ; DE Resource Bar when in combat

	If _CheckPixel($aDarkElixirStorageFull, $bCapturePixel) Then $return = True

	Return $return
EndFunc   ;==>getDarkElixirStorageFull

; Returns whether the Elixir Storage is full when in battle
Func getElixirStorageFull()
	Local $return = False
	Local $aElixirStorageFull[4] = [709, 62, 0xAE1AB3, 6] ; Elixir Resource Bar when in combat

	If _CheckPixel($aElixirStorageFull, $bCapturePixel) Then $return = True

	Return $return
EndFunc   ;==>getElixirStorageFull

; Returns whether the Gold Storage is full when in battle
Func getGoldStorageFull()
	Local $return = False
	Local $aGoldStorageFull[4] = [709, 30, 0xD4B100, 6] ; Gold Resource Bar when in combat

	If _CheckPixel($aGoldStorageFull, $bCapturePixel) Then $return = True

	Return $return
EndFunc   ;==>getGoldStorageFull

; Returns an array that only contains points inside the CoC Diamond
Func getArrayInDiamond($sourceArray)
    Local $result[UBound($sourceArray)], $counter = 0

	If IsArray($sourceArray) Then
		For $i = 0 To UBound($sourceArray) - 1
			If isInsideDiamond($sourceArray[$i]) Then
				$result[$counter] = $sourceArray[$i]
				$counter += 1
			EndIf
		Next
		ReDim $result[$counter]

		Return $result
	Else
		Return $sourceArray
	EndIf
EndFunc   ;==>getArrayInDiamond

; Used to calculate the distance between two points, because we are using X, Y differences its always a right angle triangle
Func calculateDistanceBetweenPoints($point1, $point2)
	Local $result = 0
	Local $differenceX = Abs($point1[0] - $point2[0])
	Local $differenceY = Abs($point1[1] - $point2[1])

	$result = Sqrt($differenceX ^ 2 + $differenceY ^ 2)

	Return $result
EndFunc   ;==>calculateDistanceBetweenPoints

; Gets the coordinates for the side the attack will use
Func getSideCoords($side)
	Local $aResult[5][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

	Switch $side
		Case $sideBottomRight
			Return $BottomRight
		Case $sideTopLeft
			Return $TopLeft
		Case $sideBottomLeft
			Return $BottomLeft
		Case $sideTopRight
			Return $TopRight
		Case Else
			; This should never happen unless there is a problem with the code.
	EndSwitch

	Return $aResult
EndFunc   ;==>getSideCoords

; Used to get a side name for displaying in logs
Func getSideName($side)
	Local $return = ""

	Switch $side
		Case $sideBottomRight
			$return = "Bottom Right"
		Case $sideTopLeft
			$return = "Top Left"
		Case $sideBottomLeft
			$return = "Bottom Left"
		Case $sideTopRight
			$return = "Top Right"
		Case Else
			; This should never happen unless there is a problem with the code.
	EndSwitch

	If $debugSetLog = 1 Then SetLog("Side Name is: " & $return)
	Return $return
EndFunc   ;==>getSideName

; Calculate which side co-ordinates are on, if it is the center of the screen return a random side
Func calculateSideFromXY($x, $y)
	Local $return = 0

	Select
		Case $x = $centerX And $y = $centerY ; Center of the screen
			$return = Random($sideBottomRight, $sideTopRight, 1)
		Case $x >= $centerX And $y >= $centerY ; Bottom Right Quadrant
			$return = $sideBottomRight
		Case $x <= $centerX And $y <= $centerY ; Top Left Quadrant
			$return = $sideTopLeft
		Case $x <= $centerX And $y >= $centerY ; Bottom Left Quadrant
			$return = $sideBottomLeft
		Case $x >= $centerX And $y <= $centerY ; Top Right Quadrant
			$return = $sideTopRight
		Case Else
			; This should never happen unless there is a problem with the code.
	EndSelect

	If $debugSetLog = 1 Then SetLog("Side Number is: " & $return)
	Return $return
EndFunc   ;==>calculateSideFromXY

; Used for log entries to display which wave it is, such as First, Second, etc...
Func getWaveName($numWave = 1, $maxWave = -1)
	Local $waveName

	If $numWave = $maxWave And $maxWave = 1 Then
		$waveName = "only"
	ElseIF $numWave = $maxWave Or $maxWave = -1 Then
		$waveName = "last"
	Else
		Switch $numWave
			Case 1
				$waveName = "first"
			Case 2
				$waveName = "second"
			Case 3
				$waveName = "third"
			Case Else
				$waveName = "next"
		EndSwitch
	EndIf

	Return $waveName
EndFunc   ;==>getWaveName

; Calculate how many troops to drop for the wave
Func calculateDropAmount($unitCount, $remainingWaves, $position = 0, $minTroopsPerPosition = 1)
	Local $return = Ceiling($unitCount / $remainingWaves)

	If $position <> 0 Then
		If $unitCount < ($position * $minTroopsPerPosition) Then
			$position = Floor($unitCount / $minTroopsPerPosition)
			$return = $position * $minTroopsPerPosition
		ElseIf $unitCount >= ($position * $minTroopsPerPosition) And $return < ($position * $minTroopsPerPosition) Then
			$return = $position * $minTroopsPerPosition
		EndIf
	EndIf

	Return $return
EndFunc  ;==>calculateDropAmount