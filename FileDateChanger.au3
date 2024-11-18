#include <File.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Global $hGUI
HotKeySet("{F1}" , "OpenContextMenuManager")

; Hàm mở GUI sửa context menu
Func OpenContextMenuManager()
	shellExecute(@ScriptDir & "\ContextMenuManager")
	Exit
EndFunc

; Thay đổi ngày
Func ChangeFileDates($filePath)
    ; Kiểm tra nếu file tồn tại
    If Not FileExists($filePath) Then
        MsgBox($MB_ICONERROR, "Error", "File not found: " & $filePath)
        Return
    EndIf

    ; Lấy modified file hiện tại
    Local $aModifiedFileTime = FileGetTime($filePath, 0, 0)
    If @error Or Not IsArray($aModifiedFileTime) Or UBound($aModifiedFileTime) < 6 Then
        MsgBox($MB_ICONERROR, "Error", "Failed to get file time: " & $filePath)
        Return
    EndIf
	
		
	; Lấy created file hiện tại
    Local $aCreatedFileTime = FileGetTime($filePath, 1, 0)
    If @error Or Not IsArray($aCreatedFileTime) Or UBound($aCreatedFileTime) < 6 Then
        MsgBox($MB_ICONERROR, "Error", "Failed to get file time: " & $filePath)
        Return
    EndIf

    
    ; Tạo GUI
    $hGUI = GUICreate("Change File Dates", 350, 260)
    
	
    Local $displayPath = $filePath
    Local $maxLength = 50

    If StringLen($displayPath) > $maxLength Then
		$displayPath = StringLeft($displayPath, 3) & "..." & StringTrimLeft($displayPath, StringLen($displayPath) - ($maxLength - 4))
	EndIf
	GUICtrlCreateLabel("File Path:", 10, 10, 130, 20)
    GUICtrlCreateLabel($displayPath, 10, 30, 330, 40)

    GUICtrlCreateLabel("Current Created Date:", 10, 80, 150, 20)
    GUICtrlCreateLabel(_GetFormattedDate($aCreatedFileTime), 160, 80, 220, 20)
	
	GUICtrlCreateLabel("Current Modified Date:", 10, 100, 150, 20)
    GUICtrlCreateLabel(_GetFormattedDate($aModifiedFileTime), 160, 100, 220, 20)
	
	GUICtrlCreateLabel("YYYY", 160, 140, 25, 20)
	GUICtrlCreateLabel("MM", 198, 140, 14, 20)
	GUICtrlCreateLabel("DD", 223, 140, 14, 20)
	GUICtrlCreateLabel("HH", 253, 140, 14, 20)
	GUICtrlCreateLabel("MM", 278, 140, 14, 20)
	GUICtrlCreateLabel("SS", 303, 140, 14, 20)

    GUICtrlCreateLabel("New Created Date:", 10, 160, 150, 40)
    Local $inputCreated1 = GUICtrlCreateInput($aCreatedFileTime[0], 155, 155, 35, 20)
	Local $inputCreated2 = GUICtrlCreateInput($aCreatedFileTime[1], 195, 155, 20, 20)
	Local $inputCreated3 = GUICtrlCreateInput($aCreatedFileTime[2], 220, 155, 20, 20)
	Local $inputCreated4 = GUICtrlCreateInput($aCreatedFileTime[3], 250, 155, 20, 20)
	Local $inputCreated5 = GUICtrlCreateInput($aCreatedFileTime[4], 275, 155, 20, 20)
	Local $inputCreated6 = GUICtrlCreateInput($aCreatedFileTime[5], 300, 155, 20, 20)
	
	GUICtrlCreateLabel("New Modified Date:", 10, 180, 150, 40)
	Local $inputModified1 = GUICtrlCreateInput($aModifiedFileTime[0], 155, 175, 35, 20)
	Local $inputModified2 = GUICtrlCreateInput($aModifiedFileTime[1], 195, 175, 20, 20)
	Local $inputModified3 = GUICtrlCreateInput($aModifiedFileTime[2], 220, 175, 20, 20)
	Local $inputModified4 = GUICtrlCreateInput($aModifiedFileTime[3], 250, 175, 20, 20)
	Local $inputModified5 = GUICtrlCreateInput($aModifiedFileTime[4], 275, 175, 20, 20)
	Local $inputModified6 = GUICtrlCreateInput($aModifiedFileTime[5], 300, 175, 20, 20)

    Local $saveButton = GUICtrlCreateButton("Save", 125, 220, 100, 30)
	
	GUICtrlCreateLabel("F1 = Option", 10, 230, 80, 20)
	
    GUISetState(@SW_SHOW, $hGUI)

    ; Xử lý sự kiện
    While 1
        Local $msg = GUIGetMsg()
        Switch $msg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $saveButton
                Local $newCreated = _GetDateFromInputs($inputCreated1, $inputCreated2, $inputCreated3, $inputCreated4, $inputCreated5, $inputCreated6)
				Local $newModified = _GetDateFromInputs($inputModified1, $inputModified2, $inputModified3, $inputModified4, $inputModified5, $inputModified6)

                ; Kiểm tra đúng định dạng
                If StringLen($newCreated) <> 14 Then
                    MsgBox($MB_ICONERROR, "Error", "Invalid created date format. Please use YYYY MM DD HH MM SS format.")
                    ContinueLoop
                EndIf
				
				If StringLen($newModified) <> 14 Then
                    MsgBox($MB_ICONERROR, "Error", "Invalid modified date format. Please use YYYY MM DD HH MM SS format.")
                    ContinueLoop
                EndIf
				
				; Sửa ngày
				If FileSetTime($filePath, $newCreated, 1) <> 1 Then
                    MsgBox($MB_ICONERROR, "Error", "An error occurred whilst saving created date.")
                    ContinueLoop
                EndIf
				If FileSetTime($filePath, $newModified, 0) <> 1 Then
                    MsgBox($MB_ICONERROR, "Error", "An error occurred whilst saving modified date.")
                    ContinueLoop
                EndIf
				
                MsgBox($MB_ICONINFORMATION, "Success", "File date changed successfully!")
                ExitLoop
        EndSwitch

    WEnd
    GUIDelete($hGUI)
	Exit
EndFunc


Func _GetFormattedDate($aFileTime)
    Return StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $aFileTime[0], $aFileTime[1], $aFileTime[2], $aFileTime[3], $aFileTime[4], $aFileTime[5])
EndFunc


Func _GetDateFromInputs($yearCtrl, $monthCtrl, $dayCtrl, $hourCtrl, $minuteCtrl, $secondCtrl)
    Local $year = GUICtrlRead($yearCtrl)
    Local $month = GUICtrlRead($monthCtrl)
    Local $day = GUICtrlRead($dayCtrl)
    Local $hour = GUICtrlRead($hourCtrl)
    Local $minute = GUICtrlRead($minuteCtrl)
    Local $second = GUICtrlRead($secondCtrl)

    ; Chuẩn hóa
    If StringLen($month) = 1 Then $month = "0" & $month
    If StringLen($day) = 1 Then $day = "0" & $day
    If StringLen($hour) = 1 Then $hour = "0" & $hour
    If StringLen($minute) = 1 Then $minute = "0" & $minute
    If StringLen($second) = 1 Then $second = "0" & $second

    ; Kiểm tra
    If Not StringIsDigit($year) Or StringLen($year) <> 4 Then Return ""
    If Not StringIsDigit($month) Or StringLen($month) <> 2 Then Return ""
    If Not StringIsDigit($day) Or StringLen($day) <> 2 Then Return ""
    If Not StringIsDigit($hour) Or StringLen($hour) <> 2 Then Return ""
    If Not StringIsDigit($minute) Or StringLen($minute) <> 2 Then Return ""
    If Not StringIsDigit($second) Or StringLen($second) <> 2 Then Return ""

    Return $year & $month & $day & $hour & $minute & $second
EndFunc

; Kiểm tra nếu script được gọi từ context menu
If $CmdLine[0] > 0 Then
    ChangeFileDates($CmdLine[1])
Else
    OpenContextMenuManager()
EndIf