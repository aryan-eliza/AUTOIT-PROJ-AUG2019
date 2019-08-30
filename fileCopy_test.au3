#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
    
;Assign the source file path to a variable.
Local $sSourceFilePath = "C:\AUTOIT-PROJ-AUG2019\Soup_ofTheDay"
    
;Assign the destination directory to a variable.
 Local $sDestPath = "C:\AUTOIT-PROJ-AUG2019\SOTD_Archive"
    
;Execute the copy function.
Local $iCopyStatus = FileCopy($sSourceFilePath, $sDestPath, $FC_CREATEPATH)
    
;Display the status after checking the returned value.
 If $iCopyStatus Then
    MsgBox($MB_SYSTEMMODAL, "", "Copy Success")
Else
    MsgBox($MB_SYSTEMMODAL, "", "Copy Failed")
 EndIf    