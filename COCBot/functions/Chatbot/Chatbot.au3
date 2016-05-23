; ==========================================================
; Chatbot script fixed by ChrisDuh
; Mod version: 5.3.1
; Made for MyBot <http://mybot.run>
; I cannot be held responsible for what this chatbot says
; See bottom of file for more info
; ==========================================================

#include <Process.au3>
#include <Array.au3>

$chatIni = ""

; SETTINGS =================================================
Global $ChatbotChatGlobal       = False
Global $ChatbotScrambleGlobal   = False
Global $ChatbotSwitchLang       = False
Global $ChatbotChatClan         = False
Global $ChatbotClanUseCleverbot = False
Global $ChatbotClanUseSimsimi   = False
Global $ChatbotClanUseResponses = False
Global $ChatbotClanAlwaysMsg    = False
Global $ChatbotUsePushbullet    = False
Global $ChatbotPbSendNew        = False
Global $ClanMessages = ""
Global $ClanResponses = ""
Global $GlobalMessages1 = ""
Global $GlobalMessages2 = ""
Global $GlobalMessages3 = ""
Global $GlobalMessages4 = ""
; END SETTINGS =============================================

; GUI ======================================================

Global $chkGlobalChat;
Global $chkGlobalScramble;
Global $chkSwitchLang;
Global $chkchatdelay
Global $ichkchatdelay
Global $ChatbotChatDelayLabel   = ""
Global $chatdelaycount = 0

Global $chkClanChat;
Global $chkUseResponses;
Global $chkUseCleverbot;
Global $chkUseSimsimi;
Global $chkUseGeneric;
Global $chkChatPushbullet;
Global $chkPbSendNewChats;

Global $editGlobalMessages1;
Global $editGlobalMessages2;
Global $editGlobalMessages3;
Global $editGlobalMessages4;

Global $editResponses;
Global $editGeneric;

Global $ChatbotQueuedChats[0]
Global $ChatbotReadQueued = False
Global $ChatbotReadInterval = 0
Global $ChatbotIsOnInterval = False

Func ChatbotReadSettings()
   If IniRead($chatIni, "global", "use",      "False") = "True" Then $ChatbotChatGlobal       = True
   If IniRead($chatIni, "global", "scramble", "False") = "True" Then $ChatbotScrambleGlobal   = True
   If IniRead($chatIni, "global", "swlang",   "False") = "True" Then $ChatbotSwitchLang       = True


   If IniRead($chatIni, "clan", "use",        "False") = "True" Then $ChatbotChatClan         = True
   If IniRead($chatIni, "clan", "cleverbot",  "False") = "True" Then $ChatbotClanUseCleverbot = True
   If IniRead($chatIni, "clan", "simsimi",    "False") = "True" Then $ChatbotClanUseSimsimi   = True
   If IniRead($chatIni, "clan", "responses",  "False") = "True" Then $ChatbotClanUseResponses = True
   If IniRead($chatIni, "clan", "always",     "False") = "True" Then $ChatbotClanAlwaysMsg    = True
   If IniRead($chatIni, "clan", "pushbullet", "False") = "True" Then $ChatbotUsePushbullet    = True
   If IniRead($chatIni, "clan", "pbsendnew",  "False")  = "True" Then $ChatbotPbSendNew       = True

   $ClanMessages = StringSplit(IniRead($chatIni, "clan", "genericMsg", "Testing on Chat|Hey all"), "|", 2)
   Local $ClanResponses0 = StringSplit(IniRead($chatIni, "clan", "responseMsg", "keyword:Response|hello:Hi, Welcome to the clan|hey:Hey, how's it going?"), "|", 2)
   Local $ClanResponses1[UBound($ClanResponses0)][2];
   For $a = 0 To UBound($ClanResponses0) - 1
	  $TmpResp = StringSplit($ClanResponses0[$a], ":", 2)
	  If UBound($TmpResp) > 0 Then
		 $ClanResponses1[$a][0] = $TmpResp[0]
	  Else
		 $ClanResponses1[$a][0] = "<invalid>"
	  EndIf
	  If UBound($TmpResp) > 1 Then
		 $ClanResponses1[$a][1] = $TmpResp[1]
	  Else
		 $ClanResponses1[$a][1] = "<undefined>"
	  EndIf
   Next

   $ClanResponses = $ClanResponses1

   $GlobalMessages1 = StringSplit(IniRead($chatIni, "global", "globalMsg1", "War Clan Recruiting|Active War Clan accepting applications"), "|", 2)
   $GlobalMessages2 = StringSplit(IniRead($chatIni, "global", "globalMsg2", "Join now|Apply now"), "|", 2)
   $GlobalMessages3 = StringSplit(IniRead($chatIni, "global", "globalMsg3", "250 war stars min|Must have 250 war stars"), "|", 2)
   $GlobalMessages4 = StringSplit(IniRead($chatIni, "global", "globalMsg4", "Adults Only| 18+"), "|", 2)
EndFunc

Func ChatbotCreateGui()
   $chatIni = $sProfilePath & "\" & $sCurrProfile & "\chat.ini"
   ChatbotReadSettings()
   $tabChat = GUICtrlCreateTabItem("Chat")

   Local $x = 30, $y = 150

   GUICtrlCreateGroup("Global Chat", $x - 20, $y - 20, 225, 375)
    $y -= 5
   $chkGlobalChat = GUICtrlCreateCheckbox("Advertise in global", $x - 5, $y)
   GUICtrlSetTip($chkGlobalChat, "Use global chat to send messages")
   GUICtrlSetState($chkGlobalChat, $ChatbotChatGlobal)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 18
   $chkGlobalScramble = GUICtrlCreateCheckbox("Scramble global chats", $x - 5, $y)
   GUICtrlSetTip($chkGlobalScramble, "Scramble the message pieces defined in the textboxes below to be in a random order")
   GUICtrlSetState($chkGlobalScramble, $ChatbotScrambleGlobal)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 18
   $chkSwitchLang = GUICtrlCreateCheckbox("Switch languages", $x - 5, $y)
   GUICtrlSetTip($chkSwitchLang, "Switch languages after spamming for a new global chatroom")
   GUICtrlSetState($chkSwitchLang, $ChatbotSwitchLang)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 22
  $ChatbotChatDelayLabel = GUICtrlCreateLabel("Chat Delay", $x - 5, $y)
   GUICtrlSetTip($ChatbotChatDelayLabel, "Delay chat between number of bot cycles")
   $chkchatdelay = GUICtrlCreateInput("0", $x + 50, $y - 1, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
   GUICtrlSetLimit(-1, 2)
   $y += 20
   $editGlobalMessages1 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages1, @CRLF), $x - 5, $y, 200, 70)
   GUICtrlSetTip($editGlobalMessages1, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 70
   $editGlobalMessages2 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages2, @CRLF), $x - 5, $y, 200, 70)
   GUICtrlSetTip($editGlobalMessages2, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 70
   $editGlobalMessages3 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages3, @CRLF), $x - 5, $y, 200, 70)
   GUICtrlSetTip($editGlobalMessages3, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 70
   $editGlobalMessages4 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages4, @CRLF), $x - 5, $y, 200, 70)
   GUICtrlSetTip($editGlobalMessages4, "Take one item randomly from this list (one per line) and add it to create a message to send to global")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 70
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $x = 255
   $y = 150

   GUICtrlCreateGroup("Clan Chat", $x - 20, $y - 20, 225, 375)
   $chkClanChat = GUICtrlCreateCheckbox("Chat in clan chat", $x - 5, $y)
   GUICtrlSetTip($chkClanChat, "Use clan chat to send messages")
   GUICtrlSetState($chkClanChat, $ChatbotChatClan)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkUseResponses = GUICtrlCreateCheckbox("Use custom responses", $x - 5, $y)
   GUICtrlSetTip($chkUseResponses, "Use the keywords and responses defined below")
   GUICtrlSetState($chkUseResponses, $ChatbotClanUseResponses)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkUseCleverbot = GUICtrlCreateCheckbox("Use cleverbot responses", $x - 5, $y)
   GUICtrlSetTip($chkUseCleverbot, "Get responses from cleverbot.com")
   GUICtrlSetState($chkUseCleverbot, $ChatbotClanUseCleverbot)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkUseSimsimi = GUICtrlCreateCheckbox("Use simsimi responses", $x - 5, $y)
   GUICtrlSetTip($chkUseSimsimi, "Get responses from simsimi.com")
   GUICtrlSetState($chkUseSimsimi, $ChatbotClanUseSimsimi)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkUseGeneric = GUICtrlCreateCheckbox("Use generic chats", $x - 5, $y)
   GUICtrlSetTip($chkUseGeneric, "Use generic chats if reading the latest chat failed or there are no new chats")
   GUICtrlSetState($chkUseGeneric, $ChatbotClanAlwaysMsg)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkChatPushbullet = GUICtrlCreateCheckbox("Use PushBullet or Telegram for chatting", $x - 5, $y)
   GUICtrlSetTip($chkChatPushbullet, "Send and recieve chats via pushbullet or telegram. Use BOT <myvillage> GETCHATS <interval|NOW|STOP> to get the latest clan chat as an image, and BOT <myvillage> SENDCHAT <chat message> to send a chat to your clan")
   GUICtrlSetState($chkChatPushbullet, $ChatbotUsePushbullet)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25
   $chkPbSendNewChats = GUICtrlCreateCheckbox("Notify me new clan chat", $x - 5, $y)
   GUICtrlSetTip($chkPbSendNewChats, "Will send an image of your clan chat via pushbullet & telegram when a new chat is detected. Not guaranteed to be 100% accurate.")
   GUICtrlSetState($chkPbSendNewChats, $ChatbotPbSendNew)
   GUICtrlSetOnEvent(-1, "ChatGuiCheckboxUpdate")
   $y += 25

   $editResponses = GUICtrlCreateEdit(_ArrayToString($ClanResponses, ":", -1, -1, @CRLF), $x - 5, $y, 200, 85)
   GUICtrlSetTip($editResponses, "Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
   $y += 90
   $editGeneric = GUICtrlCreateEdit(_ArrayToString($ClanMessages, @CRLF), $x - 5, $y, 200, 85)
   GUICtrlSetTip($editGeneric, "Generic messages to send, one per line")
   GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")

   GUICtrlCreateTabItem("")
   
   ChatGuicheckboxUpdateAT()
   
EndFunc

Func ChatGuiCheckboxUpdate()
   $SimsimiOld = $ChatbotClanUseSimsimi
   $CleverbotOld = $ChatbotClanUseCleverbot

   $ChatbotChatGlobal       = GuiCtrlRead($chkGlobalChat)     = $GUI_CHECKED
   $ChatbotScrambleGlobal   = GuiCtrlRead($chkGlobalScramble) = $GUI_CHECKED
   $ChatbotSwitchLang       = GuiCtrlRead($chkSwitchLang)     = $GUI_CHECKED

   $ChatbotChatClan         = GuiCtrlRead($chkClanChat)       = $GUI_CHECKED
   $ChatbotClanUseCleverbot = GuiCtrlRead($chkUseCleverbot)   = $GUI_CHECKED
   $ChatbotClanUseSimsimi   = GuiCtrlRead($chkUseSimsimi)     = $GUI_CHECKED
   $ChatbotClanUseResponses = GuiCtrlRead($chkUseResponses)   = $GUI_CHECKED
   $ChatbotClanAlwaysMsg    = GuiCtrlRead($chkUseGeneric)     = $GUI_CHECKED
   $ChatbotUsePushbullet    = GuiCtrlRead($chkChatPushbullet) = $GUI_CHECKED
   $ChatbotPbSendNew        = GuiCtrlRead($chkPbSendNewChats) = $GUI_CHECKED

   If $ChatbotClanUseSimsimi And $CleverbotOld Then
	  GUICtrlSetState($chkUseCleverbot, 4) ; 4 = unchecked
	  $ChatbotClanUseCleverbot = False
   ElseIf $ChatbotClanUseCleverbot And $SimsimiOld Then
	  GUICtrlSetState($chkUseSimsimi, 4)
	  $ChatbotClanUseSimsimi = False
   EndIf

   If $ChatbotClanUseCleverbot And $ChatbotClanUseSimsimi Then
	  GUICtrlSetState($chkUseSimsimi, 4)
	  $ChatbotClanUseSimsimi = False
   EndIf

   IniWrite($chatIni, "global", "use",      $ChatbotChatGlobal)
   IniWrite($chatIni, "global", "scramble", $ChatbotScrambleGlobal)
   IniWrite($chatIni, "global", "swlang",   $ChatbotSwitchLang)

   IniWrite($chatIni, "clan", "use",        $ChatbotChatClan)
   IniWrite($chatIni, "clan", "cleverbot",  $ChatbotClanUseCleverbot)
   IniWrite($chatIni, "clan", "simsimi",    $ChatbotClanUseSimsimi)
   IniWrite($chatIni, "clan", "responses",  $ChatbotClanUseResponses)
   IniWrite($chatIni, "clan", "always",     $ChatbotClanAlwaysMsg)
   IniWrite($chatIni, "clan", "pushbullet", $ChatbotUsePushbullet)
   IniWrite($chatIni, "clan", "pbsendnew",  $ChatbotPbSendNew)
   
   ChatGuiCheckboxUpdateAT()
   
EndFunc

Func ChatGuiCheckboxUpdateAT()
	If GUICtrlRead($chkGlobalChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkGlobalScramble , $GUI_ENABLE)
		GUICtrlSetState($chkSwitchLang , $GUI_ENABLE)
		GUICtrlSetState($ChatbotChatDelayLabel , $GUI_ENABLE)
		GUICtrlSetState($chkchatdelay , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages1 , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages2 , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages3 , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages4 , $GUI_ENABLE)
	Else
		GUICtrlSetState($chkGlobalScramble , $GUI_DISABLE)
		GUICtrlSetState($chkSwitchLang , $GUI_DISABLE)
		GUICtrlSetState($ChatbotChatDelayLabel , $GUI_DISABLE)
		GUICtrlSetState($chkchatdelay , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages1 , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages2 , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages3 , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages4 , $GUI_DISABLE)
	EndIf
	If GUICtrlRead($chkClanChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseResponses , $GUI_ENABLE)
		GUICtrlSetState($chkUseCleverbot , $GUI_ENABLE)
		GUICtrlSetState($chkUseSimsimi , $GUI_ENABLE)
		GUICtrlSetState($chkUseGeneric , $GUI_ENABLE)
		GUICtrlSetState($chkChatPushbullet , $GUI_ENABLE)
		GUICtrlSetState($chkPbSendNewChats , $GUI_ENABLE)
		GUICtrlSetState($editResponses , $GUI_ENABLE)
		GUICtrlSetState($editGeneric , $GUI_ENABLE)
		GUICtrlSetState($ChatbotChatDelayLabel , $GUI_ENABLE)
		GUICtrlSetState($chkchatdelay , $GUI_ENABLE)
	Else
		GUICtrlSetState($chkUseResponses , $GUI_DISABLE)
		GUICtrlSetState($chkUseCleverbot , $GUI_DISABLE)
		GUICtrlSetState($chkUseSimsimi , $GUI_DISABLE)
		GUICtrlSetState($chkUseGeneric , $GUI_DISABLE)
		GUICtrlSetState($chkChatPushbullet , $GUI_DISABLE)
		GUICtrlSetState($chkPbSendNewChats , $GUI_DISABLE)
		GUICtrlSetState($editResponses , $GUI_DISABLE)
		GUICtrlSetState($editGeneric , $GUI_DISABLE)
	EndIf
EndFunc

Func ChatGuiCheckboxDisableAT()
	For $i = $chkGlobalChat To $editGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
EndFunc
Func ChatGuiCheckboxEnableAT()
	For $i = $chkGlobalChat To $editGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_ENABLE)
	Next
	ChatGuiCheckboxUpdateAT()
EndFunc


Func ChatGuiEditUpdate()
   $glb1 = GUICtrlRead($editGlobalMessages1)
   $glb2 = GUICtrlRead($editGlobalMessages2)
   $glb3 = GUICtrlRead($editGlobalMessages3)
   $glb4 = GUICtrlRead($editGlobalMessages4)

   $cResp = GUICtrlRead($editResponses)
   $cGeneric = GUICtrlRead($editGeneric)

   ; how 2 be lazy 101 =======
   $glb1 = StringReplace($glb1, @CRLF, "|")
   $glb2 = StringReplace($glb2, @CRLF, "|")
   $glb3 = StringReplace($glb3, @CRLF, "|")
   $glb4 = StringReplace($glb4, @CRLF, "|")

   $cResp = StringReplace($cResp, @CRLF, "|")
   $cGeneric = StringReplace($cGeneric, @CRLF, "|")

   IniWrite($chatIni, "global", "globalMsg1", $glb1)
   IniWrite($chatIni, "global", "globalMsg2", $glb2)
   IniWrite($chatIni, "global", "globalMsg3", $glb3)
   IniWrite($chatIni, "global", "globalMsg4", $glb4)

   IniWrite($chatIni, "clan", "genericMsg", $cGeneric)
   IniWrite($chatIni, "clan", "responseMsg", $cResp)

   ChatbotReadSettings()
   ; =========================
EndFunc

; FUNCTIONS ================================================
; All of the following return True if the script should
; continue running, and false otherwise
Func ChatbotChatOpen() ; open the chat area
   Click (20, 379, 1) ; open chat
   If _Sleep(1000) Then Return
   Return True
EndFunc

Func ChatbotSelectClanChat() ; select clan tab
   Click (220, 21, 1) ; switch to clan
   If _Sleep(1000) Then Return
   Click ( 220, 21, 1) ; scroll to top
   If _Sleep(1000) Then Return
   Return True
EndFunc

Func ChatbotSelectGlobalChat() ; select global tab
   Click ( 76, 22, 1) ; switch to global
   If _Sleep(1000) Then Return
   Return True
EndFunc

Func ChatbotChatClose() ; close chat area
   Click ( 330, 384, 1) ; close chat
   waitMainScreen()
   Return True
EndFunc

Func ChatbotChatClanInput() ; select the textbox for clan chat
   Click ( 112, 97, 1) ; select the textbox
   If _Sleep(1000) Then Return
   Return True
EndFunc

Func ChatbotChatGlobalInput() ; select the textbox for global chat
   Click ( 112, 63, 1) ; select the textbox
   If _Sleep(1000) Then Return
   Return True
EndFunc

Func ChatbotChatInput($message) ; input the text
   SendText ($message)
   Return True
EndFunc

Func ChatbotChatSendClan() ; click send
   If _Sleep(1000) Then Return
   Click ( 282, 95, 1) ; send
   If _Sleep(2000) Then Return
   Return True
EndFunc

Func ChatbotChatSendGlobal() ; click send
   If _Sleep(1000) Then Return
   Click ( 284, 62, 1) ; send
   If _Sleep(2000) Then Return
   Return True
EndFunc

Func ChatbotStartTimer()
   $ChatbotStartTime = TimerInit()
EndFunc

Func ChatbotIsInterval()
   $Time_Difference = TimerDiff($ChatbotStartTime)
   If $Time_Difference > $ChatbotReadInterval * 1000 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

; Returns the response from cleverbot or simsimi, if any
Func runHelper($msg, $isCleverbot) ; run a script to get a response from cleverbot.com or simsimi.com
   Dim $DOS, $Message = ''

   $command = '" /c' & @ScriptDir & '\lib\phantomjs.exe phantom-cleverbot-helper.js'
	If Not $isCleverbot Then
		$command = '" /c' & @ScriptDir & '\lib\phantomjs.exe phantom-simsimi-helper.js'
	EndIf

   $DOS = Run(@ComSpec & $command & $msg & '"', "", @SW_HIDE, 8)
   $HelperStartTime = TimerInit()
   SetLog("Waiting for chatbot helper...")
   While ProcessExists($DOS)
	  ProcessWaitClose($DOS, 10)
	  SetLog("Still waiting for chatbot helper...")
	  $Time_Difference = TimerDiff($HelperStartTime)
	  If $Time_Difference > 50000 Then
		 SetLog("Chatbot helper is taking too long!", $COLOR_RED)
		 ProcessClose($DOS)
		 _RunDos("taskkill -f -im phantomjs.exe") ; force kill
		 Return ""
	  EndIf
   WEnd
   $Message = ''
   While 1
	  $Message &= StdoutRead($DOS)
	  If @error Then
		 ExitLoop
	  EndIf
   WEnd
   Return StringStripWS($Message, 7)
EndFunc

Func ChatbotIsLastChatNew() ; returns true if the last chat was not by you, false otherwise
   _CaptureRegion()
   For $x = 38 To 261
	  If _ColorCheck(_GetPixelColor($x, 129), Hex(0x78BC10, 6), 5) Then Return True ; detect the green menu button
   Next
   Return False
EndFunc

Func ChatbotPushbulletSendChat()
   If Not $ChatbotUsePushbullet Then Return
   _CaptureRegion(0, 0, 320, 675)
   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
   Local $Time = @HOUR & "." & @MIN

   $ChatFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
   _GDIPlus_ImageSaveToFile($hBitmap, $dirLoots & $ChatFile)
   _GDIPlus_ImageDispose($hBitmap)
   ;push the file
   SetLog("Chatbot: Sent chat image", $COLOR_GREEN)
   _PushFile($ChatFile, "Loots", "image/jpeg", $iOrigPushB & " | Last Clan Chats" & "\n" & $ChatFile)
   ;wait a second and then delete the file
   _Sleep(500)
   Local $iDelete = FileDelete($dirLoots & $ChatFile)
   If Not ($iDelete) Then SetLog("Chatbot: Failed to delete temp file", $COLOR_RED)
EndFunc

Func ChatbotPushbulletQueueChat($Chat)
   If Not $ChatbotUsePushbullet Then Return
   _ArrayAdd($ChatbotQueuedChats, $Chat)
EndFunc

Func ChatbotPushbulletQueueChatRead()
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadQueued = True
EndFunc

Func ChatbotPushbulletStopChatRead()
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadInterval = 0
   $ChatbotIsOnInterval = False
EndFunc

Func ChatbotPushbulletIntervalChatRead($Interval)
   If Not $ChatbotUsePushbullet Then Return
   $ChatbotReadInterval = $Interval
   $ChatbotIsOnInterval = True
   ChatbotStartTimer()
EndFunc

Func ChangeLanguageToEN()
   Click ( 820, 585, 1) ;settings
   If _Sleep(500) Then Return
   Click ( 433, 120, 1) ;settings tab
   If _Sleep(500) Then Return
   Click ( 210, 420, 1)  ;language
   If _Sleep(1000) Then Return
   Click ( 171, 183, 1)  ;English
   If _Sleep(500) Then Return
   Click ( 513, 426, 1)  ;language
   If _Sleep(1000) Then Return
EndFunc

Func ChangeLanguageToFRA()
   Click ( 820, 585, 1) ;settings
   If _Sleep(500) Then Return
   Click ( 433, 120, 1) ;settings tab
   If _Sleep(500) Then Return
   Click ( 210, 420, 1)  ;language
   If _Sleep(1000) Then Return
   Click ( 173, 228, 1)  ;French
   If _Sleep(500) Then Return
   Click ( 513, 426, 1)  ;language
   If _Sleep(1000) Then Return
EndFunc

; MAIN SCRIPT ==============================================

Func ChatbotMessage() ; run the chatbot
	If $ChatbotChatGlobal Then
	  SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
   ElseIf $ChatbotChatClan Then
	  SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
   EndIf
   If $ChatbotChatGlobal Then
	If $chatdelaycount < $ichkchatdelay Then
	SetLog("Delaying Chat " & ($ichkchatdelay-$chatdelaycount) & " more times" , $COLOR_GREEN)
	$chatdelaycount += 1
	Return
	ElseIf $chatdelaycount = $ichkchatdelay Then
	$chatdelaycount = 0
	EndIf
	  If Not ChatbotChatOpen() Then Return
	  SetLog("Chatbot: Sending chats to global", $COLOR_GREEN)
	  ; assemble a message
	  Local $Message[4]
	  $Message[0] = $GlobalMessages1[Random(0, UBound($GlobalMessages1) - 1, 1)]
	  $Message[1] = $GlobalMessages2[Random(0, UBound($GlobalMessages2) - 1, 1)]
	  $Message[2] = $GlobalMessages3[Random(0, UBound($GlobalMessages3) - 1, 1)]
	  $Message[3] = $GlobalMessages4[Random(0, UBound($GlobalMessages4) - 1, 1)]
	  If $ChatbotScrambleGlobal Then
		 _ArrayShuffle($Message)
	  EndIf
	  ; Send the message
	  If Not ChatbotSelectGlobalChat() Then Return
	  If Not ChatbotChatGlobalInput() Then Return
	  If Not ChatbotChatInput(_ArrayToString($Message, " ")) Then Return
	  If Not ChatbotChatSendGlobal() Then Return
	  If Not ChatbotChatClose() Then Return

	  If $ChatbotSwitchLang Then
		 SetLog("Chatbot: Switching languages", $COLOR_GREEN)
		 ChangeLanguageToFRA()
		 waitMainScreen()
		 ChangeLanguageToEN()
		 waitMainScreen()
	  EndIf
   EndIf

   If $ChatbotChatClan Then
	  If Not ChatbotChatOpen() Then Return
	  SetLog("Chatbot: Sending chats to clan", $COLOR_GREEN)
	  If Not ChatbotSelectClanChat() Then Return

	  $SentClanChat = False

	  If $ChatbotReadQueued Then
		 ChatbotPushbulletSendChat()
		 $ChatbotReadQueued = False
		 $SentClanChat = True
	  ElseIf $ChatbotIsOnInterval Then
		 If ChatbotIsInterval() Then
			ChatbotStartTimer()
			ChatbotPushbulletSendChat()
			$SentClanChat = True
		 EndIf
	  EndIf

	  If UBound($ChatbotQueuedChats) > 0 Then
		 SetLog("Chatbot: Sending pushbullet chats", $COLOR_GREEN)

		 For $a = 0 To UBound($ChatbotQueuedChats) - 1
			$ChatToSend = $ChatbotQueuedChats[$a]
			If Not ChatbotChatClanInput() Then Return
			If Not ChatbotChatInput($ChatToSend) Then Return
			If Not ChatbotChatSendClan() Then Return
		 Next

		 Dim $Tmp[0] ; clear queue
		 $ChatbotQueuedChats = $Tmp

		 ChatbotPushbulletSendChat()

		 If Not ChatbotChatClose() Then Return
		 SetLog("Chatbot: Done", $COLOR_GREEN)
		 Return
	  EndIf

	  If ChatbotIsLastChatNew() Then
		 ; get text of the latest message
		 $ChatMsg = StringStripWS(getOcrAndCapture("coc-latinA", 30, 148, 270, 13, False), 7)
		 SetLog("Found chat message: " & $ChatMsg, $COLOR_GREEN)
		 $SentMessage = False

		 If $ChatMsg = "" Or $ChatMsg = " " Then
			If $ChatbotClanAlwaysMsg Then
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			   If Not ChatbotChatSendClan() Then Return
			   $SentMessage = True
			EndIf
		 EndIf

		 If $ChatbotClanUseResponses And Not $SentMessage Then
			For $a = 0 To UBound($ClanResponses) - 1
			   If StringInStr($ChatMsg, $ClanResponses[$a][0]) Then
				  $Response = $ClanResponses[$a][1]
				  SetLog("Sending response: " & $Response, $COLOR_GREEN)
				  If Not ChatbotChatClanInput() Then Return
				  If Not ChatbotChatInput($Response) Then Return
				  If Not ChatbotChatSendClan() Then Return
				  $SentMessage = True
				  ExitLoop
			   EndIf
			Next
		 EndIf

		 If ($ChatbotClanUseCleverbot Or $ChatbotClanUseSimsimi) And Not $SentMessage Then
			$ChatResponse = runHelper($ChatMsg, $ChatbotClanUseCleverbot)
			SetLog("Got cleverbot response: " & $ChatResponse, $COLOR_GREEN)
			If StringInStr($ChatResponse, "No response") Or $ChatResponse = "" Or $ChatResponse = " " Then
			   If $ChatbotClanAlwaysMsg Then
				  If Not ChatbotChatClanInput() Then Return
				  If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
				  If Not ChatbotChatSendClan() Then Return
				  $SentMessage = True
			   EndIf
			Else
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ChatResponse) Then Return
			   If Not ChatbotChatSendClan() Then Return
			EndIf
		 EndIf

		 If Not $SentMessage Then
			If $ChatbotClanAlwaysMsg Then
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			   If Not ChatbotChatSendClan() Then Return
			EndIf
		 EndIf

		 ; send it via pushbullet if it's new
		 ; putting the code here makes sure the (cleverbot, specifically) response is sent as well :P
		 If $ChatbotUsePushbullet And $ChatbotPbSendNew Then
			If Not $SentClanChat Then ChatbotPushbulletSendChat()
		 EndIf
	  ElseIf $ChatbotClanAlwaysMsg Then
		 If Not ChatbotChatClanInput() Then Return
		 If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
		 If Not ChatbotChatSendClan() Then Return
	  EndIf

	  If Not ChatbotChatClose() Then Return
   EndIf
   If $ChatbotChatGlobal Then
	  SetLog("Chatbot: Done chatting", $COLOR_GREEN)
   ElseIf $ChatbotChatClan Then
	  SetLog("Chatbot: Done chatting", $COLOR_GREEN)
   EndIf
EndFunc

#cs ----------------------------------------------------------------------------
   AutoIt Version: 3.6.0
   This file was made to software MyBot v5.3.1
   Author:         ChrisDuh

   Script Function: Sends chat messages in global and clan chat
#ce ----------------------------------------------------------------------------