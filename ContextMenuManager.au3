#RequireAdmin
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Global $hGUI

Func OpenContextMenuManager()
    ; Đóng GUI hiện tại nếu có
    If IsHWnd($hGUI) Then
        GUIDelete($hGUI)
    EndIf
        
    ; Tạo GUI sửa context menu
    $hGUI = GUICreate("Context Menu Manager", 300, 150)
    Local $addButton = GUICtrlCreateButton("Add to Context Menu", 50, 30, 200, 30)
    Local $removeButton = GUICtrlCreateButton("Remove from Context Menu", 50, 80, 200, 30)
    GUISetState(@SW_SHOW, $hGUI)

    ; Xử lý sự kiện
    While 1
        Local $msg = GUIGetMsg()
        Switch $msg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $addButton
                AddContextMenu()
                ExitLoop
            Case $removeButton
                RemoveContextMenu()
                ExitLoop
        EndSwitch
    WEnd
    GUIDelete($hGUI)
    Exit
EndFunc

; Đường dẫn của Registry key
Global $keyPath = "HKEY_CLASSES_ROOT\*\shell\DateChange"
Global $commandPath = $keyPath & "\command"

; Đường dẫn tới script
Global $scriptPath = @ScriptDir & "\FileTimeChanger"

; Thêm vào context menu
Func AddContextMenu()
    RegWrite($keyPath, "", "REG_SZ", "Change File Dates") ; Thiết lập tên hiển thị trong context menu
    RegWrite($commandPath, "", "REG_SZ", '"' & $scriptPath & '" "%1"') ; Đường dẫn tới script của bạn
    MsgBox($MB_ICONINFORMATION, "Success", "Context menu item added successfully!")
EndFunc

; Xóa trong context menu
Func RemoveContextMenu()
    RegDelete($keyPath)
    MsgBox($MB_ICONINFORMATION, "Success", "Context menu item removed successfully!")
EndFunc

OpenContextMenuManager()