/*
<NSIS图片水纹特效脚本>
脚本编写：zhfi
特别感谢：Restools，X-Star
*/

!AddPluginDir ".\"
!AddIncludeDir ".\"

!include MUI.nsh

; --------------------------------------------------
; General settings.

Name "WaterCtrl_Test Example"
OutFile "WaterCtrl_Test.exe"
SetCompressor /SOLID lzma     

ReserveFile "${NSISDIR}\Plugins\x86-ansi\system.dll"
ReserveFile waterctrl.dll

;SetFont tahoma 8

; --------------------------------------------------
; MUI interface settings.
 !define MUI_FINISHPAGE_NOAUTOCLOSE
; --------------------------------------------------
; Insert MUI pages.
!define MUI_WELCOMEFINISHPAGE_BITMAP WizModernImage-Is.bmp

; Installer pages
!define MUI_PAGE_CUSTOMFUNCTION_PRE pre
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE leave
 !insertmacro MUI_PAGE_WELCOME

 !insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_Pre pre
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE leave
 !insertmacro MUI_PAGE_FINISH

; --------------------------------------------------
; Languages.

 !insertmacro MUI_LANGUAGE "SimpChinese"

Function .onGUIEnd
SetPluginUnload manual
waterctrl::disablewater
System::Free
FunctionEnd

Function .onInit
InitPluginsDir 
SetOutPath $PLUGINSDIR
File waterctrl.dll
SetOutPath $TEMP
FunctionEnd

Function Pre
  System::Call 'user32::LoadImage(i,t,i,i,i,i,) i (0,"$PLUGINSDIR\modern-wizard.bmp",0,0,0,0x2010) .s'
Pop $R0
	System::Call '$PLUGINSDIR\waterctrl::enablewater(i,i,i,i,i,i) i ($HWNDPARENT,0,0,$R0,3,50)'
	System::Call '$PLUGINSDIR\waterctrl::setwaterparent(i $HWNDPARENT)'
	System::Call '$PLUGINSDIR\waterctrl::flattenwater()'
	System::Call '$PLUGINSDIR\waterctrl::waterblob(i,i,i,i) i (70,198,10,1000)'
FunctionEnd

Function leave
	System::Call '$PLUGINSDIR\waterctrl::disablewater()'
FunctionEnd

 Section "Dummy" SecDummy
 SectionEnd


