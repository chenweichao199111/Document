Name "test"
OutFile "test.exe"

AutoCloseWindow true

!include "MUI.nsh"
!insertmacro MUI_LANGUAGE "English"

Function .onInit
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"
    File "test.gif"
    newadvsplash::show /NOUNLOAD 2000 1000 2000   "$PLUGINSDIR\test.gif" ;�����²�����
    Sleep 2000 ;�ӳ�2��
    MessageBox mb_ok "��ʾ���"
FunctionEnd


Section ""
;��ʽ����
SectionEnd
