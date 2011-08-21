;; unfortunately, git's performance on windows is very bad
;; as far as I understand, that's because git heavily relies on Linux idioms that aren't supported natively on Windows
;; the best startup time for git I managed myself was 0.1s, but this is still too slow
;; for example, vc-find-file-hook runs git as much as 11 times, which slows down find-file to a crawl

;; to fix that, I've done two thingies:
;; 1) stripped down %GIT_HOME%\..\cmd\git.cmd (see replace-git-cmd.bat next to this file)
;; 2) disabled vc-find-file-hook to provide acceptable performance of find-file
;; luckily, disabling vc-find-file-hook doesn't turn off vc-dir and vc-diff that I use often

;; this begs for more universal solution (e.g. disabling this hook only if the file is under Git)
;; but I'll leave that as TBI for now
(defadvice vc-find-file-hook (around disable-vc-find-file-hook-on-windows activate))
