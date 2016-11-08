@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl %HOMEPATH%/surveyprocess/chkMtoH.pl %1 %2
goto endofperl
:WinNT
perl %HOMEPATH%/surveyprocess/chkMtoH.pl %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
:endofperl
