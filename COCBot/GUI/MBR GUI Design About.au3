; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design About
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GUIAbout()
	
	$hAboutGUI = GUICreate(GetTranslated(12,1, "About Us"), 461, 400, 1, 65, -1, $WS_EX_MDICHILD, $frmbot)
	
	GUISetIcon($pIconLib, $eIcnGUI)
	;GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGUIAbout") ; Run this function when the secondary GUI [X] is clicked
GUISetBkColor ($COLOR_WHITE)
GUICtrlSetBkColor(-1, $COLOR_WHITE)
	
Local $x = 30, $y = 30
;	$grpCredits = GUICtrlCreateGroup("Credits", $x - 20, $y - 20, 450, 375)
		$lblBckGrnd = GUICtrlCreateLabel("", $x - 20, $y - 20, 450, 375)  ; adds fixed white background for entire tab, if using "Labels"
		GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$txtCredits = "My Bot is brought to you by a worldwide team of open source"  & @CRLF & _
						"programmers and a vibrant community of forum members!"
		$lblCredits1 = GUICtrlCreateLabel($txtCredits, $x - 5, $y - 5, 400, 30)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_NAVY)
		$y += 38
		$txtCredits = "Please visit our web forums:"
		$lblCredits2 = GUICtrlCreateLabel($txtCredits, $x+20, $y, 180, 30)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
		$labelMyBotURL = GUICtrlCreateLabel("https://mybot.run/forums", $x + 198, $y, 150, 20)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y += 27
		$lblCredits3 = GUICtrlCreateLabel("Credits belong to following programmers for donating their time:", $x - 5, $y , 420, 20)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1,10, $FW_BOLD)
		$y += 25
		$txtCredits =	"Active developers: "  &  @CRLF & _
						"Cosote, Hervidero, Kaganus, LunaEclipse, MonkeyHunter, ProMac, Rumbla, Sardo, Trlopes, Zengzeng"  &  @CRLF & @CRLF & _
                        "Developers no longer active: "  &  @CRLF & _
						"Antidote, AtoZ, Barracoda, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, Knowjack, Safar46, Saviart, TheMaster1st, and others"
		$lbltxtCredits1 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 410,95, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 100
		$txtCredits = "Special thanks to all contributing forum members helping " & @CRLF & "to make this software better! "
		$lbltxtCredits2 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 390,30, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER),0)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
		$y += 45
		$txtCredits =	"The latest release of 'My Bot' can be found at:"
		$lbltxtNewVer = GUICtrlCreateLabel($txtCredits, $x - 5, $y, 400,15, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 20
		$labelForumURL = GUICtrlCreateLabel("https://mybot.run/forums/index.php?/forum/4-official-releases/", $x+25, $y, 450, 20)
					GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y += 25
		$txtWarn =	"By running this program, the user accepts all responsibility that arises from the use of this software."  & @CRLF & _
						"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
						"the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
						"Public License for more details. The license can be found in the main code folder location."  & @CRLF & _
						"Copyright (C) 2015-2016 MyBot.run"
		$lbltxtWarn1 = GUICtrlCreateLabel($txtWarn, $x , $y, 410, 56, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT, $ES_CENTER),0)
			GUICtrlSetColor(-1, 0x000053)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 6, $FW_BOLD)

EndFunc
