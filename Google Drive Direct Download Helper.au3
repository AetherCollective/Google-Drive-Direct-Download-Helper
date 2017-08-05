#include <MsgBoxConstants.au3>
Global $sClipboard, $BYPASS, $WinTitle = "Google Drive Direct Download Helper"
RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $WinTitle, "REG_SZ", @ScriptFullPath)
Opt("TrayIconHide", 1)
AdlibRegister("_CheckClipBoardForGoogleDriveLink")
While 1
	Sleep(60000)
WEnd
Func _CheckClipBoardForGoogleDriveLink()
	$sClipboard = ClipGet()
	If $sClipboard = $BYPASS Then Return 1
	Select
		Case Not StringInStr($sClipboard, "https://drive.google.com/file/d/") = False
			_ConvertToDirectLink("https://drive.google.com/file/d/")
		Case Not StringInStr($sClipboard, "https://drive.google.com/open?id=") = False
			_ConvertToDirectLink("https://drive.google.com/open?id=")
	EndSelect
EndFunc   ;==>_CheckClipBoardForGoogleDriveLink
Func _ConvertToDirectLink($sBaseURL)
	If MsgBox(BitOR($MB_YESNO, $MB_TOPMOST), $WinTitle, "A Google Drive link has been detected in your clipboard:" & @CRLF & $sClipboard & @CRLF & @CRLF & "Would you like to convert this link into a direct download?") = $IDYES Then
		Local $iBaseURLLength = StringLen($sBaseURL)
		$sClipboard = StringTrimLeft($sClipboard, $iBaseURLLength)
		Local $iFileIDEndPointLength = StringInStr($sClipboard, "/")
		Local $IClipboardLength = StringLen($sClipboard)
		If $iFileIDEndPointLength <> False Then $sClipboard = StringTrimRight($sClipboard, $IClipboardLength - $iFileIDEndPointLength + 1)
		ClipPut("https://drive.google.com/uc?export=download&id=" & $sClipboard)
	Else
		$BYPASS = $sClipboard
	EndIf
EndFunc   ;==>_ConvertToDirectLink
