#include "prettyConsoleLog.au3"
#include <MsgBoxConstants.au3>
#include <date.au3>
    ;~ prettyConsoleLog("Let's replace the slashes in the date:" &$date)
    ;~ prettyConsoleLog("This is your source directory:" &$sourceDir)
    ;~ prettyConsoleLog("This is the folder were we'll create the backup directory:" &$backupDir)
    ;~ prettyConsoleLog("Todays date is:" &_NowDate())

Func BackupInCurrentFolder (Const $sourceDir, Const $backupDir)
    $date = StringReplace (_NowDate(), "/", "_")
    $FinalBackupDir = ($backupDir & "\" & $date &"_" & getFolderOrFileName ($sourceDir))
    If FileExists ($FinalBackupDir) > 0 Then 
        $FinalBackupDir = ($FinalBackupDir & "_Copy")
    EndIf


    DirCopy($sourceDir, $FinalBackupDir, $FC_CREATEPATH)


EndFunc    

;If given a file path, returns whatever is after the final "\" character
Func getFolderOrFileName(Const $path)
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
    EndFunc

BackupInCurrentFolder ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")

