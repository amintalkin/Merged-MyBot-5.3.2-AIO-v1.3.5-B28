; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab MOD
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$tabMOD = GUICtrlCreateTabItem("Mods")
	; SmartZap Settings
	Local $x = 35, $y = 150
    $grpStatsMisc = GUICtrlCreateGroup("SmartZap", $x - 20, $y - 20, 440, 115)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 20, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y - 7, 24, 24)
		$chkSmartLightSpell = GUICtrlCreateCheckbox("Use Lightning Spells to Zap Drills", $x + 20, $y - 5, -1, -1)
			$txtTip = "Check this to drop Lightning Spells on top of Dark Elixir Drills." & @CRLF & @CRLF & _
					  "Remember to go to the tab 'troops' and put the maximum capacity " & @CRLF & _
					  "of your spell factory and the number of spells so that the bot " & @CRLF & _
					  "can function perfectly."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_CHECKED)
		$chkSmartZapDB = GUICtrlCreateCheckbox("Only Zap Drills in Dead Bases", $x + 20, $y + 21, -1, -1)
			$txtTip = "It is recommended you only zap drills in dead bases as most of the " & @CRLF & _
					  "Dark Elixir in a live base will be in the storage."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblSmartZap = GUICtrlCreateLabel("Min. amount of Dark Elixir:", $x - 10, $y + 48, 160, -1, $SS_RIGHT)
		$txtMinDark = GUICtrlCreateInput("200", $x + 155, $y + 45, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = "The value here depends a lot on what level your Town Hall is, " & @CRLF & _
					  "and what level drills you most often see."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkSmartZapSaveHeroes = GUICtrlCreateCheckbox("Don't Zap on Town Hall Snipe when Heroes Deployed", $x + 20, $y + 69, -1, -1)
			$txtTip = "This will stop SmartZap from zapping a base on a Town Hall Snipe " & @CRLF & _
					  "if your heroes were deployed. " & @CRLF & @CRLF & _
					  "This protects their health so they will be ready for battle sooner!"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	Local $x = 236, $y = 150
		$picSmartZap = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y + 3, 24, 24)
		$lblSmartZap = GUICtrlCreateLabel("0", $x + 60, $y + 5, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
			$txtTip = "Number of dark elixir zapped during the attack with lightning."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 160, $y + 40, 24, 24)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x + 60, $y + 40, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
			$txtTip = "Amount of used spells."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Save for Collector Settings
	Local $x = 35, $y = 265
	$grpSaveTroops = GUICtrlCreateGroup("Save Troops for Collectors", $x - 20, $y - 20, 440, 70)
		$chkChangeAllSides = GUICtrlCreateCheckbox("Use All Sides", $x - 10, $y - 5, -1, -1)
			$txtTip = "Change to All Sides attack if less than " & $percentCollectors & "% of collectors near RED LINE."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkChangeAllSides")
		$lblChangeAllSides = GUICtrlCreateLabel("Minimum near Red Line:", $x + 105, $y - 2, 125, -1, $SS_RIGHT)
		$txtPercentCollectors = GUICtrlCreateInput("80", $x + 235, $y - 5, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Suggestions: " & @CRLF & _
					  "     Barch lvl. 6 and above use 70%." & @CRLF & _
					  "     Barch lvl. 5 use 80%." & @CRLF & _
					  "     Barch lvl. 4 and below use 90%."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 100)
			GUICtrlSetOnEvent(-1, "txtPercentCollectors")
		$lblChangeAllSidesPercent = GUICtrlCreateLabel("% Collectors.", $x + 275, $y - 2, -1, -1)
		$lblDistance = GUICtrlCreateLabel("Maximum Distance to Redline:", $x - 10, $y + 24, 240, -1, $SS_RIGHT)
		$txtDistance = GUICtrlCreateInput("50", $x + 235, $y + 21, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Maximum number of pixels between the collector and the Redline." & @CRLF & _
					  "     Recommended: 50 pixels."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 100)
			GUICtrlSetOnEvent(-1, "txtDistance")
		$lblDistancePixels = GUICtrlCreateLabel("pixels.", $x + 275, $y + 24, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;;;;;;;;;;;;;;;;;
    ;;; Multy-Farming
    ;;;;;;;;;;;;;;;;;
	Local $x = 35, $y = 335
	; IceCube (Multy-Farming Revamp v1.6)
	$grpMultyFarming = GUICtrlCreateGroup( "Multy-Farming with Smart Switch", $x - 20, $y - 20, 440, 60)
	;$x -= 10
		$chkMultyFarming = GUICtrlCreateCheckbox(GetTranslated(17,1, "Multy-Farming"), $x - 10, $y -7, -1 , -1)
			$txtTip = GetTranslated(17,3, "Will switch account and attack, then switch back")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "MultiFarming")
		$chkSwitchDonate = GUICtrlCreateCheckbox(GetTranslated(6,1, "Donate"), $x - 10, $y +13, -1, -1)
			$txtTip = GetTranslated(17,4, "Will switch account For Donate, then switch back")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "SwitchAndDonate")
		$Account = GUICtrlCreateInput("2", $x +170, $y -7, 15, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(17,5, "How many account to use For multy-farming")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblmultyAcc = GUICtrlCreateLabel(GetTranslated(17,2, "How Many:"), $x +100, $y -2, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblmultyAccBtn = GUICtrlCreateLabel(GetTranslated(17, 20, "Fast Switch:"), $x +95, $y +18, -1, -1)
			$txtTip = GetTranslated(17, 21, "Fast switch between accounts")
			GUICtrlSetTip(-1, $txtTip)
		$btnmultyAcc1 = GUICtrlCreateButton("#1", $x + 170, $y +15, 20, 18)
			$txtTip = GetTranslated(17,22, "Switch to Main Account")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc1")
			GUICtrlSetState(-1, $GUI_DISABLE)			
		$btnmultyAcc2 = GUICtrlCreateButton("#2", $x + 200, $y +15, 20, 18)
			$txtTip = GetTranslated(17,23, "Switch to Second Account")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc2")
			GUICtrlSetState(-1, $GUI_DISABLE)	
		$btnmultyAcc3 = GUICtrlCreateButton("#3", $x + 230, $y +15, 20, 18)
			$txtTip = GetTranslated(17,24, "Switch to Third Account")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc3")
			GUICtrlSetState(-1, $GUI_DISABLE)	
		$btnmultyAcc4 = GUICtrlCreateButton("#4", $x + 260, $y +15, 20, 18)
			$txtTip = GetTranslated(17,25, "Switch to Fourth Account")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc4")
			GUICtrlSetState(-1, $GUI_DISABLE)	
		$btnmultyDetectAcc = GUICtrlCreateButton("?", $x + 290, $y +15, 20, 18)
			$txtTip = GetTranslated(17,26, "Detect Current Account")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyDetectAcc")
			GUICtrlSetState(-1, $GUI_ENABLE)				
	; IceCube (Multy-Farming Revamp v1.6)
					GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Android Settings
	Local $x = 35, $y = 440
	$grpHideAndroid = GUICtrlCreateGroup("Android Options", $x - 20, $y - 20, 440, 85)
		$cmbAndroid = GUICtrlCreateCombo("", $x - 10, $y - 5, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Use this to select the Android Emulator to use with this profile."
			GUICtrlSetTip(-1, $txtTip)
			setupAndroidComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbAndroid")
		$lblAndroidInstance = GUICtrlCreateLabel("Instance:", $x + 130, $y - 2 , 60, 21, $SS_RIGHT)
		$txtAndroidInstance = GUICtrlCreateInput("", $x + 200, $y - 5, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			$txtTip = "Enter the Instance to use with this profile."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "txtAndroidInstance")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkHideTaskBar = GUICtrlCreateCheckbox("Hide Taskbar Icon", $x - 10, $y + 20, 120, -1)
			$txtTip = "This will hide the android client from the taskbar when you press the Hide button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "HideTaskbar")
		$lblHideTaskBar = GUICtrlCreateLabel("Warning: May cause erratic behaviour, uncheck if you have problems.", $x - 10, $y + 45, 340, 30, $SS_LEFT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	Local $x = 35, $y = 395
	$grpHideCoCStats = GUICtrlCreateGroup("CoCStats", $x - 20, $y - 20, 440, 45)
;	$x -= 10
		;$x = 141
		;$y = 375
		$chkCoCStats = GUICtrlCreateCheckbox("Activate CoCStats", $x -10, $y - 5, -1 , -1)
		$txtTip = "Activate sending raid results to CoCStats.com"
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCoCStats")
		;$x = 270
		;$y = 375
		$lblAPIKey = GUICtrlCreateLabel("API Key" & ":", $x +150 , $y-2, -1, -1, $SS_LEFT)
		;$x = 135
		;$y = 375
		$txtAPIKey = GUICtrlCreateInput("", $x +200, $y-5 , 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$txtTip = "Join in CoCStats.com and input API Key here"
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		
GUICtrlCreateTabItem("")