; #FUNCTION# ====================================================================================================================
; Name ..........: ClickRandomly
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boju (2015)
; Modified ......: ProMac 2016
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ClickZone($x, $y, $Offset = 7, $times = 1, $speed = 0, $OutScreen = 731, $scale = 3, $density = 1, $centerX = 0, $centerY = 0)

	Local $BasY
	If $y - $Offset > $OutScreen Then
		$BasY = $y
	Else
		$BasY = $y - $Offset
	EndIf
	Local $TempBot[4] = [$x - $Offset, $BasY, $x + $Offset, $y + $Offset]

	ClickR($TempBot, $x, $y, $times, $speed, $OutScreen, $scale, $density, $centerX, $centerY)

EndFunc   ;==>ClickZone

Func ClickR($boundingBox, $x, $y, $times = 1, $speed = 0, $OutScreen = 731, $scale = 3, $density = 1, $centerX = 0, $centerY = 0)

	Local Const $PI = 3.141592653589793
	Local $boxWidth = $boundingBox[2] - $boundingBox[0]
	Local $boxHeight = $boundingBox[3] - $boundingBox[1]
	Local $boxCenterX = $boundingBox[0] + $boxWidth / 2 + $centerX
	Local $boxCenterY = $boundingBox[1] + $boxHeight / 2 + $centerY
	Local $loopStartTime = TimerInit()
	Do
		Local $angle = Random() * 2 * $PI
		Local $xR = Random()
		If $xR = 0 Then $xR = 0.000001
		Local $distance = $scale * (($xR ^ (-1.0 / $density)) - 1)
		Local $offsetX = $distance * Sin($angle)
		Local $offsetY = $distance * Cos($angle)
		$x = $boxCenterX + $boxWidth * $offsetX / 4
		$y = $boxCenterY + $boxHeight * $offsetY / 4
		If TimerDiff($loopStartTime) > 5000 Then
			$x = $boxCenterX
			$y = $boxCenterY
			ExitLoop
		EndIf
	Until $x >= $boundingBox[0] And $x <= $boundingBox[2] And _
			$y >= $boundingBox[1] And $y <= $boundingBox[3]
	If $y > $OutScreen Then
		$y = $OutScreen
	Else
		$y = $y
	EndIf
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			Click($x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		Click($x, $y)
	EndIf
EndFunc   ;==>ClickR


