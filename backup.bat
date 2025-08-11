@echo off
setlocal

REM === Configuration ===
set "DOWNLOADS_FOLDER=%USERPROFILE%\Downloads"
set "BACKUP_FOLDER=D:\EAPoCVL_Backups"
set "DB_NAME=EAPoC_VL"
set "SQL_SERVER=localhost"
set "LOG_FILE=%BACKUP_FOLDER%\restore_log.txt"

REM === Start Logging ===
echo. >> "%LOG_FILE%"
echo ===== [%DATE% %TIME%] Starting Database Restore ===== >> "%LOG_FILE%"

REM Step 1: Find latest .bak in Downloads
for /f "delims=" %%F in ('powershell -NoProfile -Command ^
    "Get-ChildItem -Path '%DOWNLOADS_FOLDER%' -Filter '*.bak' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { $_.FullName }"') do (
    set "LATEST_DOWNLOAD=%%F"
)

if not defined LATEST_DOWNLOAD (
    echo [%DATE% %TIME%] No .bak file found in Downloads. >> "%LOG_FILE%"
    echo No backup file found. Exiting.
    exit /b 1
)

echo [%DATE% %TIME%] Found latest backup in Downloads: %LATEST_DOWNLOAD% >> "%LOG_FILE%"

REM Step 2: Copy file to backup folder
copy /Y "%LATEST_DOWNLOAD%" "%BACKUP_FOLDER%" >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    echo [%DATE% %TIME%] Failed to copy the backup file. >> "%LOG_FILE%"
    exit /b 1
)

REM Step 3: Find latest .bak in backup folder
for /f "delims=" %%G in ('powershell -NoProfile -Command ^
    "Get-ChildItem -Path '%BACKUP_FOLDER%' -Filter '*.bak' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { $_.FullName }"') do (
    set "LATEST_BACKUP=%%G"
)

if not defined LATEST_BACKUP (
    echo [%DATE% %TIME%] No .bak file found in backup folder. >> "%LOG_FILE%"
    exit /b 1
)

echo [%DATE% %TIME%] Restoring database %DB_NAME% from: %LATEST_BACKUP% >> "%LOG_FILE%"

REM Step 4: Run restore command
sqlcmd -S %SQL_SERVER% -Q "USE master; RESTORE DATABASE [%DB_NAME%] FROM DISK = N'%LATEST_BACKUP%' WITH FILE = 1, REPLACE;" >> "%LOG_FILE%" 2>&1

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] ✅ Restore completed successfully. >> "%LOG_FILE%"
) else (
    echo [%DATE% %TIME%] ❌ Restore failed. Check above for error. >> "%LOG_FILE%"
)

endlocal
