@echo off
setlocal enabledelayedexpansion

rem Start from the current directory
set "start_directory=%CD%"

rem Collect all directories recursively
set "dir_list="
for /r "%start_directory%" %%d in (.) do (
    set "dir_list=!dir_list! "%%d""
)

rem Reverse the list of directories
set "reversed_dir_list="
for %%i in (!dir_list!) do (
    set "reversed_dir_list=%%i !reversed_dir_list!"
)

rem Display a list of directories that might be deleted
echo The following empty directories will be deleted:
for %%d in (!reversed_dir_list!) do (
    rem Check the number of files and subdirectories
    set "count=0"
    for /f %%i in ('dir /a /b %%d ^| find /c /v ""') do set "count=%%i"

    rem If count is zero, this directory is empty
    if "!count!"=="0" (
        echo %%d
    )
)

rem Ask for confirmation before deleting directories
set /p confirm="Do you want to delete these directories? (y/n): "

if /i not "!confirm!"=="y" (
    echo Deletion cancelled.
    pause
    exit /b
)

rem Process directories from deepest to shallowest, delete if empty
for %%d in (!reversed_dir_list!) do (
    set "count=0"
    for /f %%i in ('dir /a /b %%d ^| find /c /v ""') do set "count=%%i"

    if "!count!"=="0" (
        echo Deleting empty directory: %%d
        rmdir %%d
    )
)

echo All empty directories have been deleted.

pause
