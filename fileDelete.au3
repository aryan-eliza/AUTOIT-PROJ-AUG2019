#include "prettyConsoleLog.au3"
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <date.au3>
#include <array.au3>
#include <file.au3>



;~ Func BackupInCurrentFolder (Const $sourceDir, Const $backupDir)
;~     $date = StringReplace (_NowDate(), "/", "_")
;~     $FinalBackupDir = ($backupDir & "\" & $date &"_" & getFolderOrFileName ($sourceDir))
;~     If FileExists ($FinalBackupDir) > 0 Then 
;~         $FinalBackupDir = ($FinalBackupDir & "_Copy")
;~     EndIf
;~     DirCopy($sourceDir, $FinalBackupDir, $FC_CREATEPATH)
;~ EndFunc    


;~ ;~~~~~~~~~~SAVE~~~~~~~~~~~~~~~~~~~~~~~;
;~ FileGetTime ( "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive", $FT_CREATED = 1, $FT_STRING = 1 )
;~ MsgBox($MB_SYSTEMMODAL, "", "Timestamp:" & @CRLF & FileGetTime("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive", $FT_MODIFIED, 1))
;~ ;Func DeleteFiles (Const $DirFilesToRemove)
;~     ;$dateCreated = 
;~ ;~~~~~~~~~~SAVE~~~~~~~~~~~~~~~~~~~~~~~;


;~ ;~~~~~~~~~~SAVE~~~~~~~~~~~~~~~~~~~~~~~;
;~ ;Format date for use with Date UDF
;~ $fDate = StringFormat("%s/%s/%s %s:%s:%s", $Date[0], $Date[1], $Date[2], $Date[3], $Date[4], $Date[5])
;~ ;Calculate age, remove files older than seven days
;~ If _DateDiff('d', $fDate, _NowCalc()) > 7 Then ; the time
;~   If StringInStr(FileGetAttrib($fileList[$i]), 'D') Then
;~ ;~    DirRemove($sourceFolder, 1)
;~   Else
;~ ;~    FileDelete($sourceFolder & "" & $fileList[$i])
;~   EndIf
;~ ;~~~~~~~~~~SAVE~~~~~~~~~~~~~~~~~~~~~~~;







$sourceFolder = ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")
Global $fileList = _FileListToArray($sourceFolder, "*.*")
;, 1, -1, True, True) ; 0 = files and folders
Global $found[1]
_ArrayDisplay($fileList)

;Loop through array
For $i = 1 To $fileList[0]

;Retrieve creation time of file
$Date = FileGetTime($fileList[$i], 0, 0) 

; 0 modified, 1 = created
If @error Then Exit(1)

;Format date for use with Date UDF
$fDate = StringFormat("%s/%s/%s %s:%s:%s", $Date[0], $Date[1], $Date[2], $Date[3], $Date[4], $Date[5])

;Calculate age, remove files older than seven days
If _DateDiff('d', $fDate, _NowCalc()) > 7 Then ; the time
  If StringInStr(FileGetAttrib($fileList[$i]), 'D') Then

;~    DirRemove($sourceFolder, 1)
  Else
;~    FileDelete($sourceFolder & "" & $fileList[$i])
  EndIf
  _ArrayAdd($found, $fileList[$i])
  ConsoleWrite($fileList[$i] & ' deleted' & @CRLF)
Else
  ConsoleWrite('!' & $fileList[$i] & @CRLF)
EndIf
Next
$found[0] = UBound($found)
_ArrayDisplay($found, 'Deleted items')