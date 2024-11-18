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
    $hGUI = GUICreate("管理右键菜单", 300, 150)
    Local $addButton = GUICtrlCreateButton("添加到右键菜单", 50, 30, 200, 30)
    Local $removeButton = GUICtrlCreateButton("从右键菜单移除", 50, 80, 200, 30)
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
    RegWrite($keyPath, "", "REG_SZ", "修改文件时间") ; Thiết lập tên hiển thị trong context menu
    RegWrite($commandPath, "", "REG_SZ", '"' & $scriptPath & '" "%1"') ; Đường dẫn tới script của bạn
    MsgBox($MB_ICONINFORMATION, "成功", "已添加到右键菜单！")
EndFunc

; Xóa trong context menu
Func RemoveContextMenu()
    RegDelete($keyPath)
    MsgBox($MB_ICONINFORMATION, "成功", "已从右键菜单移除！")
EndFunc

OpenContextMenuManager()