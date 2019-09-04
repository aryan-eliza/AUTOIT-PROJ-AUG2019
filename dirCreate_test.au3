#include "prettyConsoleLog.au3"
#include <MsgBoxConstants.au3>
#include <date.au3>
dim $printDate
dim $path

    ;~ prettyConsoleLog("Let's replace the slashes in the date:" &$date)
    ;~ prettyConsoleLog("This is your source directory:" &$sourceDir)
    ;~ prettyConsoleLog("This is the folder were we'll create the backup directory:" &$backupDir)
    ;~ prettyConsoleLog("Todays date is:" &_NowDate())


;Backup source folder to destination and create copy if backup file already exists to avoid overwrite.
Func BackupInCurrentFolder (Const $sourceDir, Const $backupDir)
    $date = StringReplace (_NowDate(), "/", "_")
    $FinalBackupDir = ($backupDir & "\" & $date &"_" & getFolderOrFileName ($sourceDir))
    If FileExists ($FinalBackupDir) > 0 Then 
        $FinalBackupDir = ($FinalBackupDir & "_Copy")
    EndIf
    DirCopy($sourceDir, $FinalBackupDir, $FC_CREATEPATH)
EndFunc    

;If given a file path, returns token after the final "\" delimiter.
Func getFolderOrFileName(Const $path)
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
EndFunc


;get file dateTime and print to msg box in fuction 
Func GetFileTimeDate ($filePath)
    $printDate = FileGetTime( $filePath, $FT_CREATED = 1, $FT_STRING = 1 )
    MsgBox($MB_SYSTEMMODAL, "", "Timestamp:" & @CRLF & $printDate)
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
EndFunc

;GetFileTimeDate ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\*")

;Recursive function to list sub directories in msg box 
$filePath = ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\*.*")
Global $GetFileTimeDate = FileGetTime( $filePath, $FT_CREATED = 1, $FT_STRING = 1 )
SearchArchiveDir()

Func SearchArchiveDir()
    Local $hSearch = FileFindFirstFile("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\*.*")

    If $hSearch = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "Error: No files/directories matched the search pattern.")
        Return False
    EndIf
    Local $sFileName = "", $iResult = 0

    While 1
        $sFileName = FileFindNextFile($hSearch)
        If @error Then ExitLoop

        $iResult = MsgBox(BitOR($MB_SYSTEMMODAL, $MB_OKCANCEL), "", "File: " & $sFileName & @CRLF & "Date Created: " & $GetFileTimeDate)
        If $iResult <> $IDOK Then ExitLoop 
    WEnd

    FileClose($hSearch)
EndFunc   

BackupInCurrentFolder ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")