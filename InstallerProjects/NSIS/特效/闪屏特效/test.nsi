Name "test"
OutFile "test.exe"

AutoCloseWindow true

!include "MUI.nsh"
!insertmacro MUI_LANGUAGE "English"

Function .onInit
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"
    File "test.gif"
    newadvsplash::show /NOUNLOAD 2000 1000 2000   "$PLUGINSDIR\test.gif" ;调用新插件语句
    Sleep 2000 ;延迟2秒
    MessageBox mb_ok "演示完毕"
FunctionEnd


Section ""
;形式而已
SectionEnd
