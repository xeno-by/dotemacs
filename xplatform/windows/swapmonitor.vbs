Const MOVEMONITOR_NEXT = -1
Const WNDCHANGE_RESIZE_TO_FIT = 1
Const WNDCHANGE_CLIP_TO_WORKSPACE = 2 

resizeToFit = False
If WScript.Arguments.Count = 1 Then
	If WScript.Arguments(0) = "/r" Then resizeToFit = True
End If

Set wnd = CreateObject("UltraMon.Window")
If wnd.GetForegroundWindow() = True Then
	wnd.Monitor = MOVEMONITOR_NEXT
	flags = WNDCHANGE_CLIP_TO_WORKSPACE
	If resizeToFit = True Then flags = flags + WNDCHANGE_RESIZE_TO_FIT
	wnd.ApplyChanges flags
End If