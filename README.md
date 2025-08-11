Automated SQL Server Database Restore Script
Overview
This batch script automates the process of restoring a SQL Server database from the most recent .bak backup file found in your Downloads folder. It:

Finds the latest backup in your Downloads directory.

Copies it to a dedicated backup storage folder.

Identifies the latest backup in the backup folder.

Restores it to the specified SQL Server instance.

Logs all actions and results to a log file.

🛠 Requirements
Before running this script, ensure you have:

Windows (with Command Prompt and PowerShell available).

SQL Server installed and running locally or on the configured server.

sqlcmd utility available in your system PATH.

Sufficient permissions to restore databases on the target SQL Server instance.

⚙ Configuration
At the top of the script, update the following variables as needed:

Variable	Description	Default
DOWNLOADS_FOLDER	Location where .bak files are downloaded.	%USERPROFILE%\Downloads
BACKUP_FOLDER	Permanent storage location for backups.	D:\EAPoCVL_Backups
DB_NAME	Name of the database to restore.	EAPoC_VL
SQL_SERVER	SQL Server instance name or address.	localhost
LOG_FILE	File path for logging restore activity.	%BACKUP_FOLDER%\restore_log.txt

🚀 How It Works
Find Latest Backup
The script searches DOWNLOADS_FOLDER for .bak files and selects the most recently modified file.

Copy to Backup Folder
The file is copied to BACKUP_FOLDER for safe storage.

Select Latest Backup in Backup Folder
The script identifies the most recent .bak in BACKUP_FOLDER (in case you have multiple backups stored).

Restore Database
Runs a RESTORE DATABASE command via sqlcmd using the latest backup.

Logging
All steps, including errors, are appended to restore_log.txt.
