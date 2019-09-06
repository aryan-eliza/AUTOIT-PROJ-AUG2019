#include <MsgBoxConstants.au3>
#include <date.au3>
#include <Array.au3>
#include <file.au3>


dim $printDate
dim $path
dim $ageInDays
dim $today
dim $count = 1
Global $sourceDate
Global $fileTime
$filePath = ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\*.*")

;Backup directories
BackupInCurrentFolder ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")

;Look in archive and delete old files
SearchArchiveDir()

;ICACLS
;RunWait(@ComSpec & " /c " & ICACLS "C:\Scripting Projects\Weather Patterns - EAST TN 2019" /grant  REGCORP\AAikin:(RX), @WindowsDir, @SW_MINIMIZE)
;RunWait(@ComSpec & "cmd.exe /c" & "Icacls " & "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay" & "/grant " & "REGCORP\AAikin" & ":(RX)")


    #RequireAdmin
    $result = RunWait(@ComSpec & 'start /wait cmd.exe', '/c ICACLS "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay" /reset BUILTIN\Users', @WindowsDir)
MsgBox($MB_SYSTEMMODAL, "", "ErrorLevel: " &$result)


;Functions
Func BackupInCurrentFolder (Const $sourceDir, Const $backupDir);Backup source folder to destination and create copy if backup file already exists to avoid overwrite.
    $date = StringReplace (_NowDate(), "/", "_")
    $FinalBackupDir = ($backupDir & "\" & $date &"_" & getFolderOrFileName ($sourceDir))
    If FileExists ($FinalBackupDir) > 0 Then
        $FinalBackupDir = ($FinalBackupDir & "_Copy")
    EndIf
    DirCopy($sourceDir, $FinalBackupDir, $FC_CREATEPATH)
EndFunc

Func getFolderOrFileName(Const $path);If given a file path, returns token after the final "\" delimiter.
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
EndFunc

Func GetFileTimeDate ($filePath);get file dateTime and print to msg box in fuction
    $printDate = FileGetTime( $filePath, $FT_CREATED = 1, $FT_STRING = 1 )
    ;MsgBox($MB_SYSTEMMODAL, "", "Timestamp:" & @CRLF & $printDate)
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
EndFunc

Func getFolderAge($filePath);get the date the file or folder was created
    Global $fileTime = FileGetTime($filePath, $FT_MODIFIED, 0);an array of yyyy/mm/dd..etc
    Global $GetFileTimeDate = FileGetTime( $filePath, $FT_MODIFIED = 1, $FT_STRING = 1 )
	prettyConsoleLog("Directory REF:" &$filePath)
    prettyConsoleLog("File created/ modified time:" &$sourceDate)
    prettyConsoleLog("File age in days:" &_DateDiff('D', $sourceDate, $today))

    $sourceDate = $fileTime[0] & "/" & $fileTime[1] & "/" & $fileTime[2]
    $today = StringSplit(_NowDate(), "/")  ;------get today's date
    $today = $today[3] & "/"& $today[1]& "/" & $today[2]
    Return _DateDiff('D', $sourceDate, $today)  ;------subtract the folder date from today's date
    ;convert that into "days" ----------- ;return the difference
EndFunc

Func SearchArchiveDir();Combs through subdirectories and gets the name and date created
	Local $aFileList = _FileListToArray("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive", "*") ;-------- List all the files and folders in the desktop directory using the default parameters.
	While $count <= $aFileList[0]
		getFolderAge("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\"&$aFileList[$count])
		$count = $count + 1
	WEnd

	If @error = 1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Path was invalid.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox($MB_SYSTEMMODAL, "", "No file(s) were found.")
		Exit
	EndIf
	; Display the results returned by _FileListToArray.
	_ArrayDisplay($aFileList, "$aFileList")

    ;Local $recursiveGetFolderAge = getFolderAge
	Local $hSearch = FileFindFirstFile($filePath)
    If $hSearch = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "Error: No files/directories matched the search pattern.")
        Return False
    EndIf
    Local $sFileName = "", $iResult = 0

    While 1
        $sFileName = FileFindNextFile($hSearch)
        ;getFolderAge($filePath)
        If @error Then ExitLoop

        $iResult = prettyConsoleLog("File: " & $sFileName & @CRLF & "Date Created: " & $GetFileTimeDate)
        If $iResult <> $IDOK Then ExitLoop
    WEnd
    FileClose($hSearch)
EndFunc

Func prettyConsoleLog(Const $message)
    Local $divider = "----------------------------------------------------------------"
    ConsoleWrite(@CRLF & $divider & @CRLF & $message & @CRLF & $divider & @CRLF & @CRLF)
EndFunc

;Future Func
    ;~ Func isExpired($numDaysToExpire, $filePath)
    ;~ $ageInDays = getFolderAge($filePath)
    ;~ If($ageInDays > $numDaysToExpire) Then
    ;~ Return True
    ;~ Else
    ;~ Return False
    ;~ Endif
    ;~ EndFunc

;Future Func
    ;~ Func deleteIfExpired( $numDaysToExpire, $filePath)
    ;~ If(isExpired($numDaysToExpire, $filePath))
    ;~ ;;do delete stuff here

    ;~ EndFunc

;Func _DateDiff($sType, $sStartDate, $sEndDate)