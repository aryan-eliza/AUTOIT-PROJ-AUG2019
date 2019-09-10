#INCLUDE <MsgBoxConstants.au3>
#INCLUDE <date.au3>
#INCLUDE <Array.au3>
#INCLUDE <file.au3>
#RequireAdmin

Dim $printDate
Dim $path
Dim $ageInDays
Dim $numDaysToExpire=5
Dim $today
Dim $count = 1
Global $sourceDate
Global $fileTime
$filePath = ("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\*.*")

;Backup directories
BackupInCurrentFolder ("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive")

;Look in archive and delete old files
SearchArchiveDir()

;ICACLS----INCOMPLETE
;RunWait(@ComSpec & " /c " & ICACLS "C:\Scripting Projects\Weather Patterns - EAST TN 2019" /grant  REGCORP\AAikin:(RX), @WindowsDir, @SW_MINIMIZE)
;RunWait(@ComSpec & "cmd.exe /c" & "Icacls " & "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay" & "/grant " & "REGCORP\AAikin" & ":(RX)")

;Hide Root Folder
FileSetAttrib("C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay", "+H")

$result = RunWait(@ComSpec & 'start /wait cmd.exe', '/c ICACLS "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay" /grant BUILTIN\Users:(F)', @WindowsDir)
MsgBox($MB_SYSTEMMODAL, "", "ErrorLevel: " &$result)

;7zip
$SoupOfTheDay_7ZIP = "SoTD_Archive_"
$SoTD_DestZIP = "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay" & $SoupOfTheDay_7ZIP ;----7 zip will zip everything into a file in this folder
$SoTD_SourceZip = "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive"
$Execute7Zip = "7z a -t7z " & $SoTD_DestZIP & " " & $SoTD_SourceZip ;----Calling 7z and telling it to zip the folder and all of it's contents
$ZipPause = "pause" ;----Pause console to see output

$ZipVarCombine = $Execute7Zip & " & " & $ZipPause  ;----Combining variables
RunWait(@ComSpec & " /c " & $ZipVarCombine)

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
    Local $tokens = StringSplit($path, "\")
    Return $tokens[UBound($tokens) -1]
EndFunc

Func getFolderAge($filePath);get the date the file or folder was created
    Local $FileTimeOrig = FileGetTime( $filePath, $FT_MODIFIED, $FT_STRING )
	$FileTime = StringLeft($FileTimeOrig, 4) & "/" & StringMid($FileTimeOrig, 5, 2) & "/" & StringMid($FileTimeOrig, 7, 2)
	    MsgBox(0, "Filetime", $FileTime)
	    prettyConsoleLog("Directory REF:" &$filePath)
        prettyConsoleLog("File created/ modified time:" &$FileTime)
        prettyConsoleLog("File age in days:" &_DateDiff('D', $FileTime, $today))
    $today = StringSplit(_NowDate(), "/")  ;------get today's date
    $today = $today[3] & "/"& $today[1]& "/" & $today[2]
	$today = @YEAR & '/' & @MON & '/' & @MDAY
        prettyConsoleLog("Here are the dates we're comparing in the _DateDiff function: $FileTime: " & $FileTime & " $today: " & $today)
    $ageInDays = _DateDiff('D', $FileTime, $today)  ;------subtract the folder date from today's date
        MsgBox(0, "AgeDays", $ageInDays)
    Return $ageInDays
EndFunc

Func SearchArchiveDir();Combs through subdirectories and gets the name and date created
	Local $aFileList = _FileListToArray("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive", "*") ;-------- List all the files and folders in the desktop directory using the default parameters.
    $count = 1
  While $count <= $aFileList[0]
        getFolderAge("C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\"&$aFileList[$count])
        DeleteIfExpired(5, "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive\"&$aFileList[$count])
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
	_ArrayDisplay($aFileList, "$aFileList")  ;----Display the results returned by _FileListToArray.
EndFunc

Func prettyConsoleLog(Const $message)
    Local $divider = "----------------------------------------------------------------"
    ConsoleWrite(@CRLF & $divider & @CRLF & $message & @CRLF & $divider & @CRLF & @CRLF)
EndFunc

Func DeleteIfExpired($numDaysToExpire, $filePathDelete)
    $ageInDays = getFolderAge($filePathDelete)
    MsgBox(0, "", "age: " & $ageInDays & @CRLF & "NumDays: " & $numDaysToExpire & @CRLF & " FilePath: " & $filePathDelete)
    If($ageInDays > $numDaysToExpire) Then
        MsgBox(0, "", "Should be deleting: " & @CRLF & $filePathDelete)
        DirRemove($filePathDelete, $DIR_REMOVE)
    Else
        Return False
    EndIf
EndFunc

;~ ;Debug function which will print the contents of an array to the console
;~ Func printArrayToConsole(ByRef $array)
;~   Local $arraySize = UBound($array)
;~   prettyConsoleLog("your array size is:" & $arraySize)
;~   Local $message = ""
;~   ConsoleWrite("here is your array" )
;~   For $arrayIndex = 0 To ($arraySize-1) Step +1
;~     ConsoleWrite($array[$arrayIndex])
;~     ConsoleWrite(@CRLF)
;~   Next
;~ EndFunc