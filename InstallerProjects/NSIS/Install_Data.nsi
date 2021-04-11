; 该脚本使用 HM VNISEdit 脚本编辑器向导产生
; Unicode is not enabled by default
; Unicode installers will not be able to run on Windows 9x!
Unicode true

; 安装程序初始定义常量
!define PRODUCT_NAME "打飞机"
!define PACK_RESOURCE_PATH_EXE_NAME "Star Force"
!define PRODUCT_VERSION "1.0.0.0"
!define PRODUCT_PUBLISHER "江西科骏实业有限公司"
!define PACK_RESOURCE_PATH "..\Builds"
!define INSTALL_DEFAULT_PATH "$PROGRAMFILES\${PACK_RESOURCE_PATH_EXE_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define /date CUR_YEAR "%Y"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow

; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

;文件版本声明
  VIProductVersion "${PRODUCT_VERSION}"
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
  ; VIAddVersionKey /LANG=2052 "Comments" "免费使用，不限分发。"
  VIAddVersionKey /LANG=2052 "CompanyName" "${PRODUCT_PUBLISHER}"
  ; VIAddVersionKey /LANG=2052 "LegalTrademarks" "flighty"
  VIAddVersionKey /LANG=2052 "LegalCopyright" "(C) ${CUR_YEAR} ${PRODUCT_PUBLISHER}"
  VIAddVersionKey /LANG=2052 "FileDescription" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}_Data"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}_Data.exe"
; Request application privileges for Windows Vista
RequestExecutionLevel admin
BrandingText "Nullsoft Install System ${NSIS_VERSION} -- built on ${__DATE__} at ${__TIME__}"
InstallDir "${INSTALL_DEFAULT_PATH}"
InstallDirRegKey ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
ShowInstDetails hide
Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File /r /x "${PACK_RESOURCE_PATH_EXE_NAME}_BackUpThisFolder_ButDontShipItWithYourGame" /x "MonoBleedingEdge" /x "*.dll" /x "UnityCrashHandler64.exe" /x "${PACK_RESOURCE_PATH_EXE_NAME}.exe" /x "Managed" /x "il2cpp_data" /x "Resources" /x "app.info" /x "boot.config" /x "globalgamemanagers*" /x "level*" /x "sharedassets*.assets*" "${PACK_RESOURCE_PATH}\*.*"
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
; .onInit函数在程序打开时就会执行
Function .onInit
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "myMutex") i .r1 ?e'
 	Pop $R0

 	StrCmp $R0 0 +3
   MessageBox MB_OK|MB_ICONEXCLAMATION "安装程序已经在运行!"
   Abort
FunctionEnd

Function Pageshow
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
  ${If} $0 == ""
  MessageBox MB_ICONEXCLAMATION|MB_TOPMOST "安装数据包前必须安装基础包" /SD IDOK
	SetErrorLevel 4
	Quit
  ${Else}
  ;禁用浏览按钮
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1001
  EnableWindow $0 0
  ;禁用编辑的目录
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1019
  EnableWindow $0 0
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1006
  SendMessage $0 ${WM_SETTEXT} 0 "STR:您已经安装过 ${PRODUCT_NAME} ，即将进行数据安装"
  ${EndIf}
FunctionEnd
