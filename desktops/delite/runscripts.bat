@echo off

rem http://stackoverflow.com/questions/3008567/windows-batch-script-to-delete-everything-in-a-folder-except-one
ATTRIB +H runscripts.*
for /D %%i in ("*") do rd /S /Q "%%i"
del /Q "*.*"
ATTRIB -H runscripts.*

rem call delitec *.scala
call delitec -Dblas.enabled=true *.scala
if not %ERRORLEVEL%==0 exit /B %ERRORLEVEL%
echo.
echo (Phase three) DSL execution...
delite