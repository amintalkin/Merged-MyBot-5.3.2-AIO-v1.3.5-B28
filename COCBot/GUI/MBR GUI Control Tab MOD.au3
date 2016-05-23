; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Controls Tab MOD
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

Func chkSmartLightSpell()
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		$ichkSmartZap = 1
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		$ichkSmartZap = 0
	EndIf
 EndFunc   ;==>chkSmartLightSpell

Func chkSmartZapDB()
	If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
		$ichkSmartZapDB = 1
	Else
		$ichkSmartZapDB = 0
	EndIf
 EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
	If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
		$ichkSmartZapSaveHeroes = 1
	Else
		$ichkSmartZapSaveHeroes = 0
	EndIf
 EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

Func chkChangeAllSides()
	If GUICtrlRead($chkChangeAllSides) = $GUI_CHECKED Then
		$useAllSides = 1
	Else
		$useAllSides = 0
	EndIf
 EndFunc   ;==>chkChangeAllSides

Func txtPercentCollectors()
	$percentCollectors = GUICtrlRead($txtPercentCollectors)
EndFunc   ;==>txtPercentCollectors

Func txtDistance()
	$redlineDistance = GUICtrlRead($txtDistance)
EndFunc   ;==>txtDistance

;MBR GUI_MOD CONTROLS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func SwitchAndDonate()
	If GUICtrlRead($chkSwitchDonate) = $GUI_CHECKED Then
		$ichkSwitchDonate = 1
	Else
		$ichkSwitchDonate = 0
	EndIf
EndFunc   ;==>SwitchAndDonate


Func MultiFarming()
	If GUICtrlRead($chkMultyFarming) = $GUI_CHECKED Then
		$ichkMultyFarming = 1
		GUICtrlSetState($Account, $GUI_ENABLE)
		GUICtrlSetState($lblmultyAcc, $GUI_ENABLE)
		For $i = $grpControls To $cmbHoursStop
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		If GUICtrlRead($chkBotStop) = $GUI_CHECKED Then
			GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
		EndIf
	Else
		$ichkMultyFarming = 0
		GUICtrlSetState($Account, $GUI_DISABLE)
		GUICtrlSetState($lblmultyAcc, $GUI_DISABLE)
		For $i = $grpControls To $cmbHoursStop
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	EndIf
	
	; IceCube (Multy-Farming Revamp v1.6)
	GUICtrlSetState($btnmultyAcc1, $GUI_DISABLE)
	GUICtrlSetState($btnmultyAcc2, $GUI_DISABLE)
	GUICtrlSetState($btnmultyAcc3, $GUI_DISABLE)
	GUICtrlSetState($btnmultyAcc4, $GUI_DISABLE)
	If  FileExists(@ScriptDir & "\images\Multyfarming\Accmain.bmp") AND FileExists(@ScriptDir & "\images\Multyfarming\main.bmp") Then
		GUICtrlSetState($btnmultyAcc1, $GUI_ENABLE)
	EndIf
	If  FileExists(@ScriptDir & "\images\Multyfarming\AccSecond.bmp") AND FileExists(@ScriptDir & "\images\Multyfarming\Second.bmp") Then
		GUICtrlSetState($btnmultyAcc2, $GUI_ENABLE)
	EndIf
	If  FileExists(@ScriptDir & "\images\Multyfarming\AccThird.bmp") AND FileExists(@ScriptDir & "\images\Multyfarming\Third.bmp") Then
		GUICtrlSetState($btnmultyAcc3, $GUI_ENABLE)
	EndIf
	If  FileExists(@ScriptDir & "\images\Multyfarming\AccFourth.bmp") AND FileExists(@ScriptDir & "\images\Multyfarming\Fourth.bmp") Then
		GUICtrlSetState($btnmultyAcc4, $GUI_ENABLE)
	EndIf
	; IceCube (Multy-Farming Revamp v1.6)
EndFunc   ;==>MultiFarming

Func Account()
	$iAccount = GUICtrlRead($Account)
	IniWrite($config, "MOD", "Account", $iAccount)
EndFunc

; IceCube (Multy-Farming Revamp v1.6)
;Main Account
Func btnmultyDetectAcc()
	If $RunState Then Return
	LockGUI()
	SetLog("Multy-farming account detection requested ...", $COLOR_BLUE)
	SetLog("DO NOT STOP OR PAUSE BOT", $COLOR_RED)
	$RunState = True
	waitMainScreen()
	if IsMainPage()  Then
		DetectAccount()
	Else
		SetLog("Multy-farming account detection canceled", $COLOR_RED)
	EndIf
	$RunState = False
	UnLockGUI()
EndFunc
;Main Account
Func btnmultyAcc1()
	If $RunState Then Return
	LockGUI()
	SetLog("Multy-farming Main account switch requested ...", $COLOR_BLUE)
	SetLog("DO NOT STOP OR PAUSE BOT", $COLOR_RED)
		$RunState = True
	waitMainScreen()
	if IsMainPage() AND DetectCurrentAccount("Main") Then	
		checkMainScreen()
		$iSwCount = 0
		SwitchAccount("Main")
		checkMainScreen()	
		DetectAccount()
		SetLog("Multy-farming Main account switch completed", $COLOR_BLUE)
	Else
		SetLog("Multy-farming account switch canceled", $COLOR_RED)
	EndIf
	$RunState = False
	UnLockGUI()
EndFunc
;Second Account
Func btnmultyAcc2()
	If $RunState Then Return
	LockGUI()
	SetLog("Multy-farming Second account switch requested ...", $COLOR_BLUE)
	SetLog("DO NOT STOP OR PAUSE BOT", $COLOR_RED)
		$RunState = True
	waitMainScreen()
	SetLog("Multy-farming Second account switch in progress ...", $COLOR_BLUE)
	if IsMainPage() AND DetectCurrentAccount("Second") Then
		checkMainScreen()
		$iSwCount = 0
		SwitchAccount("Second")
		checkMainScreen()
		DetectAccount()
		SetLog("Multy-farming Second account switch completed", $COLOR_BLUE)
	Else
		SetLog("Multy-farming account switch canceled", $COLOR_RED)
	EndIf
	$RunState = False
	UnLockGUI()
EndFunc
;Third Account
Func btnmultyAcc3()
	If $RunState Then Return
	LockGUI()
	SetLog("Multy-farming Third account switch requested ...", $COLOR_BLUE)
	SetLog("DO NOT STOP OR PAUSE BOT", $COLOR_RED)
		$RunState = True
	waitMainScreen()
	SetLog("Multy-farming Third account switch in progress ...", $COLOR_BLUE)
	if IsMainPage() AND DetectCurrentAccount("Third") Then
		checkMainScreen()
		$iSwCount = 0
		SwitchAccount("Third")
		checkMainScreen()
		DetectAccount()
		SetLog("Multy-farming Third account switch completed", $COLOR_BLUE)
	Else
		SetLog("Multy-farming account switch canceled", $COLOR_RED)
	EndIf
	$RunState = False
	UnLockGUI()
EndFunc
;Fourth Account
Func btnmultyAcc4()
	If $RunState Then Return
	LockGUI()
	SetLog("Multy-farming Fourth account switch requested ...", $COLOR_BLUE)
	SetLog("DO NOT STOP OR PAUSE BOT", $COLOR_RED)
		$RunState = True
	waitMainScreen()
	SetLog("Multy-farming Fourth account switch in progress ...", $COLOR_BLUE)
	if IsMainPage() AND DetectCurrentAccount("Fourth") Then
		checkMainScreen()
		$iSwCount = 0
		SwitchAccount("Fourth")
		checkMainScreen()
		DetectAccount()
		SetLog("Multy-farming Fourth account switch completed", $COLOR_BLUE)
	Else
		SetLog("Multy-farming account switch canceled", $COLOR_RED)
	EndIf
	$RunState = False
	UnLockGUI()
EndFunc
;Lock GUI
Func LockGUI()

		GUICtrlSetState($btnStart, $GUI_HIDE)
		GUICtrlSetState($btnStop, $GUI_SHOW)
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		GUICtrlSetState($btnSearchMode, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)
		;$FirstAttack = 0

		$bTrainEnabled = True
		$bDonationEnabled = True
		$MeetCondStop = False
		$Is_ClientSyncError = False
		$bDisableBreakCheck = False  ; reset flag to check for early warning message when bot start/restart in case user stopped in middle
		$bDisableDropTrophy = False ; Reset Disabled Drop Trophy because the user has no Tier 1 or 2 Troops

		_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
		_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
		_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))

	    SaveConfig()
		readConfig()
		applyConfig(False) ; bot window redraw stays disabled!

		GUICtrlSetState($chkBackground, $GUI_DISABLE)

		For $i = $FirstControlToHide To $LastControlToHide ; Save state of all controls on tabs
			; Added $tabMOD to the list - Added by LunaEclipse
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert Or $i= $tabAttackCSV Or $i = $tabDeploy Or $i = $tabMOD Or $i = $tabProfiles Or $i= $tabScheduler Or $i = $tabDocOc Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			$iPrevState[$i] = GUICtrlGetState($i)
		Next
		For $i = $FirstControlToHide To $LastControlToHide ; Disable all controls in 1 go on all tabs
			; Added $tabMOD to the list - Added by LunaEclipse
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert Or $i=$tabAttackCSV Or $i = $tabDeploy Or $i = $tabMOD Or $i = $tabProfiles Or $i= $tabScheduler Or $i = $tabDocOc Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		
		ChatGuiCheckboxDisableAT()

		SetRedrawBotWindow(True)
EndFunc
;UnLock GUI
Func UnLockGUI()

		GUICtrlSetState($chkBackground, $GUI_ENABLE)
		GUICtrlSetState($btnStart, $GUI_SHOW)
		GUICtrlSetState($btnStop, $GUI_HIDE)
		GUICtrlSetState($btnPause, $GUI_HIDE)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		If $iTownHallLevel > 2 Then GUICtrlSetState($btnSearchMode, $GUI_ENABLE)
		GUICtrlSetState($btnSearchMode, $GUI_SHOW)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_ENABLE)

		; hide attack buttons if show
		GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($sBotTitleAT, $GUI_SHOW)
		GUICtrlSetState($pic2arrow, $GUI_SHOW)
		GUICtrlSetState($lblVersion, $GUI_SHOW)

	    ;$FirstStart = true
		EnableBS($HWnD, $SC_MINIMIZE)
		EnableBS($HWnD, $SC_MAXIMIZE)
		;EnableBS($HWnD, $SC_CLOSE) ; no need to re-enable close button

		SetRedrawBotWindow(False)

		For $i = $FirstControlToHide To $LastControlToHide ; Restore previous state of controls
			; Added $tabMOD to the list - Added by LunaEclipse
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabEndBattle Or $i = $tabExpert Or $i = $tabDeploy Or $i = $tabMOD Or $i = $tabProfiles Or $i= $tabScheduler Or $i = $tabDocOc Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $iPrevState[$i])
		Next

		ChatGuiCheckboxEnableAT()
		
		AndroidBotStopEvent() ; signal android that bot is now stopping

		_BlockInputEx(0, "", "", $HWnD)
		SetRedrawBotWindow(True) ; must be here at bottom, after SetLog, so Log refreshes. You could also use SetRedrawBotWindow(True, False) and let the events handle the refresh.
EndFunc
; IceCube (Multy-Farming Revamp v1.6)


	; Android Settings
Func setupAndroidComboBox()
	Local $androidString = ""
	Local $aAndroid = getInstalledEmulators()

	; Convert the array into a string
	$androidString = _ArrayToString($aAndroid, "|")

	; Set the new data of valid Emulators
	GUICtrlSetData($cmbAndroid, $androidString, $aAndroid[0])
EndFunc   ;==>setupAndroidComboBox

Func cmbAndroid()
	$sAndroid = GUICtrlRead($cmbAndroid)
	modifyAndroid()
EndFunc   ;==>cmbAndroid

Func txtAndroidInstance()
	$sAndroidInstance = GUICtrlRead($txtAndroidInstance)
	modifyAndroid()
EndFunc   ;==>$txtAndroidInstance

Func HideTaskbar()
	If GUICtrlRead($chkHideTaskBar) = $GUI_CHECKED Then
		$ichkHideTaskBar = 1
	Else
		$ichkHideTaskBar = 0
	EndIf
EndFunc   ;==>HideTaskbar

;CocStats
Func chkCoCStats()
    If GUICtrlRead($chkCoCStats) = $GUI_CHECKED Then
	  GUICtrlSetState($txtAPIKey, $GUI_ENABLE)
    Else
	  GUICtrlSetState($txtAPIKey, $GUI_DISABLE)
	EndIf
EndFunc ;==> chkCoCStats