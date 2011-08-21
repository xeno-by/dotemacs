(defun maximize-frame ()
  (w32-send-sys-command 61488)
  (sit-for 0))

(defun swap-monitor ()
  (let ((script (concat xplatform-root "/" "swapmonitor.vbs")))
  (call-process "Wscript.exe" nil t nil script "%L")))
