; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Deploy
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: LunaEclipse(January, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$tabDeploy = GUICtrlCreateTabItem("Deploy")
	; Setup values for the Deployment Waves
	Local $aDeployTroopArray[$eDeployUnused]
	Local $columnNumber, $columnWaveNumber
	
	For $i = $eArch To $eDeployUnused
		$aDeployTroopArray[$i - 1] = getTranslatedTroopName($i)
	Next

	; Convert the array into a string
	Local $troopString = _ArrayToString($aDeployTroopArray, "|")

	; Side Calculation Settings
	Local $x = 35, $y = 150
  	$grpSideCalc = GUICtrlCreateGroup("Attack Side Calculation", $x - 20, $y - 20, 440, 105)
		$lblTownHall = GUICtrlCreateLabel("Town Hall:", $x - 10, $y + 3, 70, -1, $SS_RIGHT)
		$txtTownHall = GUICtrlCreateInput("5", $x + 70, $y, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Town Hall is worth, " & @CRLF & _ 
					  "when calculating the side to attack from." & @CRLF & _
					  "     Valid values are 0 to 20."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtTownHall")
		$lblDEStorage = GUICtrlCreateLabel("Dark Elixir Storage:", $x + 275, $y + 3, 90, -1, $SS_RIGHT)
		$txtDEStorage = GUICtrlCreateInput("10", $x + 375, $y, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Dark Elixir Storage is worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect dark elixir." & @CRLF & _
					  "     Valid values are 0 to 20."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtDEStorage")
		$lblGoldStorage = GUICtrlCreateLabel("Gold Storages:", $x - 10, $y + 29, 70, -1, $SS_RIGHT)
		$txtGoldStorage = GUICtrlCreateInput("3", $x + 70, $y + 26, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Gold Storages are worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect gold." & @CRLF & _
					  "     Valid values are 0 to 20.  Setting to 0 will disable this search." & @CRLF & _
					  "     Currently disabled, because storages are counted more that once."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtGoldStorage")
		$lblElixirStorage = GUICtrlCreateLabel("Elixir Storages:", $x + 120, $y + 29, 90, -1, $SS_RIGHT)
		$txtElixirStorage = GUICtrlCreateInput("3", $x + 220, $y + 26, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Elixir Storages are worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect elixir." & @CRLF & _
					  "     Valid values are 0 to 20.  Setting to 0 will disable this search." & @CRLF & _
					  "     Currently disabled, because storages are counted more that once."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtElixirStorage")
		$lblGoldMine = GUICtrlCreateLabel("Gold Mines:", $x - 10, $y + 55, 70, -1, $SS_RIGHT)
		$txtGoldMine = GUICtrlCreateInput("1", $x + 70, $y + 52, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Gold Mines are worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect gold." & @CRLF & _
					  "     Valid values are 0 to 20.  Setting to 0 will disable this search."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtGoldMine")
		$lblElixirCollector = GUICtrlCreateLabel("Elixir Collectors:", $x + 120, $y + 55, 90, -1, $SS_RIGHT)
		$txtElixirCollector = GUICtrlCreateInput("1", $x + 220, $y + 52, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Elixir Collectors are worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect elixir." & @CRLF & _
					  "     Valid values are 0 to 20.  Setting to 0 will disable this search."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtElixirCollector")
		$lblDEDrill = GUICtrlCreateLabel("Dark Elixir Drills:", $x + 275, $y + 55, 90, -1, $SS_RIGHT)
		$txtDEDrill = GUICtrlCreateInput("2", $x + 375, $y + 52, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value determines how many points the Dark Elixir Drills are worth, " & @CRLF & _ 
					  "when calculating the side to attack from.  This will only be counted " & @CRLF & _ 
					  "if you have room in your storage to collect dark elixir." & @CRLF & _
					  "     Valid values are 0 to 20.  Setting to 0 will disable this search."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 20)
			GUICtrlSetOnEvent(-1, "txtDEDrill")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Troop Deployment Settings
	Local $x = 35, $y = 255
  	$grpTroopDeployment = GUICtrlCreateGroup("Troop Deployment", $x - 20, $y - 20, 440, 270)
		For $i = 0 to $DEPLOY_MAX_WAVES - 1	
			$columnNumber = Int($i / 8)
			$columnWaveNumber = Mod($i, 8) + 1
			
			Switch $columnNumber
				Case 0
					$x = 15
				Case 1
					$x = 160
				Case 2
					$x = 310
			EndSwitch
			
			If $columnWaveNumber = 1 Then ; First entry in the column so put a header
				$ctrlDeployHeadings[$columnNumber][0] = GUICtrlCreateLabel("#", $x + 5, $y, 15, -1, $SS_CENTER)
				$ctrlDeployHeadings[$columnNumber][1] = GUICtrlCreateLabel("Deploy", $x + 20, $y, 90, -1, $SS_CENTER)
				$ctrlDeployHeadings[$columnNumber][2] = GUICtrlCreateLabel("Pos", $x + 115, $y, 25, -1, $SS_CENTER)				
			EndIf

			$ctrlDeploy[$i][0] = GUICtrlCreateLabel(StringFormat("%02i", $i + 1), $x + 5, $y + ($columnWaveNumber * 25) - 2, 15, -1)
			$ctrlDeploy[$i][1] = GUICtrlCreateCombo(getTranslatedTroopName($eBarb), $x + 20, $y + ($columnWaveNumber * 25) - 5, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $troopString, $DEPLOY_EMPTY_STRING)
				$txtTip = "Selects which Unit or Spell to deploy."
				GUICtrlSetTip(-1, $txtTip)
				SetOnEventA(-1, "cmbDeploy", $paramByVal, $i)
			$ctrlDeploy[$i][2] = GUICtrlCreateInput("0", $x + 115, $y + ($columnWaveNumber * 25) - 3, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
				$txtTip = "Selects how many positions to deploy from." & @CRLF & @CRLF & "For spells this is the percentage distance to the target."
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetLimit(-1, 3)
				SetOnEventA(-1, "txtDeployStyle", $paramByVal, $i)
		Next			
	Local $x = 35, $y = 255
		$btnReset = GUICtrlCreateButton("Reset", $x + 355, $y + 220, 60, 25)
			GUICtrlSetOnEvent(-1, "btnReset")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")