; #FUNCTION# ====================================================================================================================
; Name ..........: actionQueue
; Description ...: Contains functions for queueing actions in the bot when in your own village
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(April, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Variables and Enums for Action Queue
Global Enum $eCleanYard, $eCollect, $eCheckTombs, $eReArm, $eReplayShare, $eNotify, $eDonateCC, $eRequestCC, $eTrain, $eBoostBarracks, $eBoostSpellFactory, $eBoostDESpellFactory, $eBoostKing, $eBoostQueen, $eBoostWarden, $eResearch, $eUpgradeBuilding, $eUpgradeWalls, $eUpgradeHeroes
Global $actionNames[$eUpgradeHeroes + 1] = ["Clean Yard", _ 
											"Collect Resources", _ 
											"Check Tombs", _ 
											"ReArm Traps", _ 
											"Share Replay", _ 
											"Send Notification", _ 
											"Donate Troops", _ 
											"Request Troops", _ 
											"Train Troops", _ 
											"Boost Barracks", _ 
											"Boost Spell Factory", _ 
											"Boost Dark Spell Factory", _ 
											"Boost King", _ 
											"Boost Queen", _ 
											"Boost Warden", _ 
											"Perform Research", _ 
											"Upgrade Buildings", _ 
											"Upgrade Walls", _ 
											"Upgrade Heroes"]

; Return whether a queued action should be performed
Func checkPerformAction($aQueue)
	; Set return value to false in case its not a valid action
	Local $result = False
	
	; Don't do any checks if its not an array, and just return default value
	If IsArray($aQueue) Then
		Switch $aQueue[0][0]
			Case $eCleanYard, $eCheckTombs To $eUpgradeHeroes
				$result = True
			Case $eCollect
				$result = $iCollectCounter > $COLLECTATCOUNT
		EndSwitch
	EndIf
	
	Return $result
EndFunc   ;==>checkPerformAction

; Perform a queued action
Func executeQueue($aQueue)
	If Not IsArray($aQueue) Then Return ; Exit for safety
	
	If checkPerformAction($aQueue) Then
		If $debugSetLog = 1 Then SetLog("Queued Action: " & $actionNames[$aQueue[0][0]] & "!", $COLOR_GREEN)

		Switch $aQueue[0][0]
			Case $eCleanYard
				CleanYard()
			Case $eCollect		
				Collect()
				$iCollectCounter = 0
			Case $eCheckTombs
				CheckTombs()
			Case $eReArm
				ReArm()
			Case $eReplayShare
				ReplayShare($iShareAttackNow)
			Case $eNotify
				ReportPushBullet()
			Case $eDonateCC
				DonateCC()
			Case $eRequestCC
				RequestCC()
			Case $eTrain
				Train()
			Case $eBoostBarracks
				BoostBarracks()
			Case $eBoostSpellFactory
				BoostSpellFactory()
			Case $eBoostDESpellFactory
				BoostDarkSpellFactory()
			Case $eBoostKing
				BoostKing()
			Case $eBoostQueen
				BoostQueen()
			Case $eBoostWarden
				BoostWarden()
			Case $eResearch
				Laboratory()
			Case $eUpgradeBuilding
				UpgradeBuilding()
			Case $eUpgradeWalls
				UpgradeWall()
			Case $eUpgradeHeroes
				UpgradeHeroes()
		EndSwitch
		
		; Use a delay if there is a delay value set
		If $aQueue[0][1] <> -1 And _Sleep($aQueue[0][1]) Then Return
	ElseIf $aQueue[0][0] = $eCollect Then
		; Failed because it had not reached collect at count, so increase counter
		$iCollectCounter += 1
	EndIf
EndFunc   ;==>executeQueue

; Sort the elements of an array into a random order
Func shuffleQueue(ByRef $aQueue, $iMultiplier = 3)
	If Not IsArray($aQueue) Then Return ; Exit for safety

    Local $oldIndex = 0, $newIndex = 0, $originalAction = -1, $originalDelay = -1

    For $i = 1 To UBound($aQueue) * $iMultiplier
        $oldIndex = Random(0, UBound($aQueue) - 1, 1)
        $newIndex = Random(0, UBound($aQueue) - 1, 1)
		; Store the original values for the move
        $originalAction = $aQueue[$oldIndex][0]
        $originalDelay = $aQueue[$oldIndex][1]

        ; Store the new values in the index
		$aQueue[$oldIndex][0] = $aQueue[$newIndex][0]
		$aQueue[$oldIndex][1] = $aQueue[$newIndex][1]
		
		; Store the original values in the new index
        $aQueue[$newIndex][0] = $originalAction
        $aQueue[$newIndex][1] = $originalDelay
    Next
EndFunc   ;==>shuffleQueue

; Create the queue based on the passed arrays, they are passed ByRef, so editing here edits the arrays in the calling functions
Func createQueue(ByRef $aQueue, ByRef $aQueueActions)
	If Not IsArray($aQueue) Or Not IsArray($aQueueActions) Then Return ; Exit for safety

	Local $debugMessage = "Action Queue Order: "

	; Reset the queue
	ReDim $aQueue[UBound($aQueueActions)][2]
		
	; Setup default queue values
	For $i = 0 To UBound($aQueueActions) - 1
		$aQueue[$i][0] = $aQueueActions[$i][0]
		$aQueue[$i][1] = $aQueueActions[$i][1]
	Next
		
	; Shuffle the queue
	shuffleQueue($aQueue)		

	If $debugSetLog = 1 Then
		For $i = 0 To UBound($aQueue) - 1
			$debugMessage &= $actionNames[$aQueue[$i][0]] & ($i < UBound($aQueue) - 1) ? ", " : ""
		Next
		
		SetLog($debugMessage, $COLOR_GREEN)
	EndIf
EndFunc   ;==>createQueue