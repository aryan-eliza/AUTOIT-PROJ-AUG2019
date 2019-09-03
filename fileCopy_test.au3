#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <date.au3>
    
;~ ;Assign the source file path to a variable.
;~ Local $sSourceFilePath = "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay"
;~ ;Assign the destination directory to a variable.
;~  Local $sDestPath = "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive"
;~ ;Execute the copy function.
;~ Local $iCopyStatus = FileCopy($sSourceFilePath, $sDestPath, $FC_CREATEPATH)
;~ ;Display the status after checking the returned value.
;~  If $iCopyStatus Then
;~     MsgBox($MB_SYSTEMMODAL, "", "Copy Success")
;~  Else if
;~     MsgBox($MB_SYSTEMMODAL, "", "Copy Failed")
;~  EndIf    

;~ Func CopyDir ($sourceDir, $destinationDir) 
;~     DirCopy($sourceDir, $destinationDir, $FC_CREATEPATH)
;~ EndFunc

;~ CopyDir ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")

;Add command to work for multiple backups 
;If backup already exists create additional backup and do not overwrite current backupfile
;Include todays date in backup directory folder name 
;Delete folders older than 7 days

Func CreateBackupDir ($sourceDir, Const $BackupDir)
    ;$BackupDir = ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")
    DirCreate($BackupDir & _NowDate)
    DirCopy($sourceDir, $BackupDir, $FC_OVERWRITE)
    ;DirCreate($BackupDir & _NowDate)
EndFunc

CreateBackupDir ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")
