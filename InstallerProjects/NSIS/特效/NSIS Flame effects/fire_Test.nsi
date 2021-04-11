/*
if you have this effects,please keep!
<NSIS Flame effects>
Writer£º¡¾Mr.Z_production ¡¤JUAN¡¿
http://blog.163.com/53_54
Thanks£ºRestools£¬zhfi,X-Star
*/

!AddPluginDir ".\"
!AddIncludeDir ".\"

!include MUI.nsh

; --------------------------------------------------
; General settings.

Name "Flame_Effects Example"
OutFile "NSIS_fire.exe"
SetCompressor /SOLID lzma

ReserveFile "${NSISDIR}\Plugins\x86-ansi\system.dll"
ReserveFile firectrl.dll

; --------------------------------------------------
; MUI interface settings.
 !define MUI_FINISHPAGE_NOAUTOCLOSE
; --------------------------------------------------
; Insert MUI pages.
!define MUI_WELCOMEFINISHPAGE_BITMAP WizModernImage-Is.bmp

; Installer pages
!define MUI_PAGE_CUSTOMFUNCTION_PRE pre
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE leave
!define MUI_WELCOMEPAGE_TEXT "About Flame effects£º\r\n\r\n1.Restools with firectrl.dll \r\n\r\n2.zhifi Waterctrl_Example \r\n\r\n3.x-star ???? \r\n\r\n5.JUAN'S COOK \r\n\r\n6. http://www.blog.163.com/53_54/"
 !insertmacro MUI_PAGE_WELCOME

 !insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_Pre pre
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE leave
 !insertmacro MUI_PAGE_FINISH

; --------------------------------------------------
; Languages.

 !insertmacro MUI_LANGUAGE "english"

Function .onGUIEnd
SetPluginUnload manual
firectrl::disablefire
System::Free
FunctionEnd

Function .onInit
InitPluginsDir
SetOutPath $PLUGINSDIR
File firectrl.dll
SetOutPath $TEMP
FunctionEnd

Function Pre
  System::Call 'user32::LoadImage(i,t,i,i,i,i,) i (0,"$PLUGINSDIR\modern-wizard.bmp",0,0,0,0x10) .s'
Pop $R0
	System::Call '$PLUGINSDIR\firectrl::enablefire(i,i,i,i,i) i ($HWNDPARENT,0,0,$R0,50)'
FunctionEnd

Function leave
	System::Call '$PLUGINSDIR\firectrl::disablefire()'
FunctionEnd

 Section "Dummy" SecDummy
 SectionEnd


