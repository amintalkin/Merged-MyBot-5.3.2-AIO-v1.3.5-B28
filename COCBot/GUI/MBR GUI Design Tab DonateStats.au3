; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cutidudz (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ DonateStats Tab
;~ -------------------------------------------------------------
#include <ListViewConstants.au3>
#include <GuiListView.au3>

Global $ImageList, $lvDonatedTroops, $DonateFile, $bm1, $bm2, $iChkDStats, $DonatedValue = 0, $iImageCompare = False, $ImageExist = "", $aFileList

Local $tabDonateStats = GUICtrlCreateTabItem("Donate Stats")
Local $x = 30, $y = 145
$lvDonatedTroops = GUICtrlCreateListView("Name|Barbarians|Archers|Giants|Goblins|Wall Breakers|Balloons|Wizards|Healers|Dragons|Pekkas|Minions|Hog Riders|Valkyries|Golems|Witches|Lava Hounds|Bowlers|Poison Spells|Earthquake Spells|Haste Spells", $x - 25, $y, 459, 363, $LVS_REPORT)
_GUICtrlListView_SetExtendedListViewStyle($lvDonatedTroops, $LVS_EX_GRIDLINES+$LVS_EX_FULLROWSELECT)
_GUICtrlListView_SetColumnWidth($lvDonatedTroops, 0, 139)

Local $chkDStats = GUICtrlCreateCheckbox("Enable", $x + 310, $y - 20, 48, 20)
$DonateStatsReset = GUICtrlCreateButton("Reset Stats", $x + 366, $y - 20, 67, 20)
_GUICtrlListView_SetExtendedListViewStyle(-1, $WS_EX_TOPMOST+$WS_EX_TRANSPARENT)
GUICtrlSetOnEvent(-1, "InitDonateStats")

For $x = 0 To 20
	_GUICtrlListView_JustifyColumn($lvDonatedTroops, $x, 2) ; Center text in all columns
Next
InitDonateStats()
