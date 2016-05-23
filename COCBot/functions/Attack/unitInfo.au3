; #CLASS# ====================================================================================================================
; Name ..........: unitInfo
; Description ...: Gets various information about units such as the number, location on the bar, clan castle spell type etc...
; Author ........: LunaEclipse(May, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

Func getDeploymentFileTroopName($kind)
    ; Troop string as an array
	; This order must exactly match the troops enum from MBR Global Variables.au3
	Local $result[$eDeployUnused + 1] = ["$eBarb", _
										 "$eArch", _
										 "$eGiant", _
										 "$eGobl", _
										 "$eWall", _
										 "$eBall", _
										 "$eWiza", _
										 "$eHeal", _
										 "$eDrag", _
										 "$ePekk", _
										 "$eMini", _
										 "$eHogs", _
										 "$eValk", _
										 "$eGole", _
										 "$eWitc", _
										 "$eLava", _
										 "$eKing", _
										 "$eQueen", _
										 "$eWarden", _
										 "$eCastle", _
										 "$eLSpell", _
										 "$eHSpell", _
										 "$eRSpell", _
										 "$eJSpell", _
										 "$eFSpell", _
										 "$ePSpell", _
										 "$eESpell", _
										 "$eHaSpell", _
										 "$eDeployWait", _
										 "$eDeployUnused"]

	Return $result[$kind]
EndFunc   ;==>getDeploymentFileTroopName

Func getTranslatedTroopName($kind)
    ; Troop string as an array
	; This order must exactly match the troops enum from MBR Global Variables.au3
	Local $result[$eDeployUnused + 1] = [GetTranslated(1, 17, "Barbarians"), _
										 GetTranslated(1, 18, "Archers"), _
										 GetTranslated(1, 19, "Giants"), _
										 GetTranslated(1, 20, "Goblins"), _
										 GetTranslated(1, 21, "Wall Breakers"), _
										 GetTranslated(1, 22, "Balloons"), _
										 GetTranslated(1, 23, "Wizards"), _
										 GetTranslated(1, 24, "Healers"), _
										 GetTranslated(1, 25, "Dragons"), _
										 GetTranslated(1, 26, "Pekkas"), _
										 GetTranslated(1, 48, "Minions"), _
										 GetTranslated(1, 49, "Hog Riders"), _
										 GetTranslated(1, 50, "Valkyries"), _
										 GetTranslated(1, 51, "Golems"), _
										 GetTranslated(1, 52, "Witches"), _
										 GetTranslated(1, 53, "Lava Hounds"), _
										 GetTranslated(7, 79, "King"), _
										 GetTranslated(7, 81, "Queen"), _
										 GetTranslated(7, 94, "Grand Warden"), _
										 GetTranslated(7, 70, "Clan Castle"), _
										 GetTranslated(8, 15, "Lightning Spell"), _
										 GetTranslated(8, 16, "Healing Spell"), _
										 GetTranslated(8, 17, "Rage Spell"), _
										 GetTranslated(8, 18, "Jump Spell"), _
										 GetTranslated(8, 19, "Freeze Spell"), _
										 GetTranslated(8, 20, "Poison Spell"), _
										 GetTranslated(8, 21, "Earthquake Spell"), _
										 GetTranslated(8, 22, "Haste Spell"), _
										 $DEPLOY_WAIT_STRING, _
										 $DEPLOY_EMPTY_STRING]

	Return $result[$kind]
EndFunc   ;==>getTranslatedTroopName

Func getTroopNumber($TroopEnumString)
	Local $result
	; Return must be a string because it doesn't work if the function returns numeric 0, because this is the same as Return False
	If StringLeft($TroopEnumString, 1) = "$" Then
		$result = Eval(StringRight($TroopEnumString, StringLen($TroopEnumString) - 1))
	Else
		$result = Eval($TroopEnumString)
	EndIf

	Return String($result)
EndFunc   ;==>getTroopNumber

Func unitLocation($kind) ; Gets the location of the unit type on the bar.
	Local $return = -1
	Local $i = 0

	; This loops through the bar array but allows us to exit as soon as we find our match.
	While $i < UBound($atkTroops)
		; $atkTroops[$i][0] holds the unit ID for that position on the deployment bar.
		If $atkTroops[$i][0] = $kind Then
			$return = $i
			ExitLoop
		EndIf

		$i += 1
	WEnd

	; This returns -1 if not found on the bar, otherwise the bar position number.
	Return $return
EndFunc   ;==>unitLocation

Func getUnitLocationArray() ; Gets the location on the bar for every type of unit.
	Local $result[$eCCSpell + 1] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

	; Loop through all the bar and assign it position to the respective unit.
	For $i = 0 To UBound($atkTroops) - 1
		If Number($atkTroops[$i][0]) <> -1 Then
			$result[Number($atkTroops[$i][0])] = $i
			If $debugSetlog = 1 Then 
				If Number($atkTroops[$i][0]) = $eCCSpell Then
					SetLog("Clan Castle Spell (" & getTranslatedTroopName($CCSpellType) & ") on button location number " & $i)
				Else
					SetLog(getTranslatedTroopName(Number($atkTroops[$i][0])) & " on button location number " & $i)
				EndIf
			EndIf
		EndIf
	Next

	; Return the positions as an array.
	Return $result
EndFunc   ;==>getUnitLocationArray

Func getCCSpellType() ; Returns the type of spell currently in the clan castle.
	Local $barLocation = unitLocation($eCCSpell)
	Local $unitText = getTranslatedTroopName($CCSpellType)

	; $barLocation is -1 if there is no entry on the deployment bar allocated as a clan castle spell.
	If $barLocation <> -1 Then
		If $debugSetlog = 1 Then SetLog($unitText & " found in the clan castle", $COLOR_PURPLE)
	Else
		If $debugSetlog = 1 Then SetLog("No clan castle spell found", $COLOR_PURPLE)
	EndIf

	return $CCSpellType
EndFunc   ;==>getCCSpellType

Func unitCount($kind) ; Gets a count of the number of units of the type specified.
	Local $numUnits = 0
	Local $unitText = getTranslatedTroopName($kind)
	Local $barLocation = unitLocation($kind)

	; $barLocation is -1 if the unit/spell type is not found on the deployment bar.
	If $barLocation <> -1 Then
		$numUnits = $atkTroops[unitLocation($kind)][1]
		If $debugSetlog = 1 Then SetLog($numUnits & " " & $unitText & " in slot " & $barLocation, $COLOR_PURPLE)
	EndIf

	Return $numUnits
EndFunc   ;==>unitCount

Func unitCountArray() ; Gets a count of the number of units for every type of unit.
	Local $result[$eCCSpell + 1] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

	; Loop through all the bar and assign its unit count to the respective unit.
	For $i = 0 To UBound($atkTroops) - 1
		If Number($atkTroops[$i][1]) > 0 Then
			$result[Number($atkTroops[$i][0])] = $atkTroops[$i][1]
			If $debugSetlog = 1 And Number($atkTroops[$i][0]) < $eCCSpell _ 
				And $atkTroops[$i][1] <> "" And Number($atkTroops[$i][1]) > 0 Then
					SetLog("Total of " & $result[Number($atkTroops[$i][1])] & " " & getTranslatedTroopName(Number($atkTroops[$i][0])) & " remaining.")			
			EndIf
		EndIf
	Next

	; Return the positions as an array.
	Return $result
EndFunc   ;==>unitCountArray