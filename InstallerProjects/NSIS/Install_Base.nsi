; 该脚本使用 HM VNISEdit 脚本编辑器向导产生
; Unicode is not enabled by default
; Unicode installers will not be able to run on Windows 9x!
Unicode true

; 安装程序初始定义常量
!define PRODUCT_NAME "打飞机"
!define PACK_RESOURCE_PATH_EXE_NAME "Star Force"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "江西科骏实业有限公司"
!define PRODUCT_WEB_SITE "http://www.kmax-arvr.com/"
!define PACK_RESOURCE_PATH "..\Builds"
!define INSTALL_DEFAULT_PATH "$PROGRAMFILES\${PACK_RESOURCE_PATH_EXE_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow

; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}_Base"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}_Base.exe"
; Request application privileges for Windows Vista
RequestExecutionLevel admin
InstallDir "${INSTALL_DEFAULT_PATH}"
InstallDirRegKey ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
ShowInstDetails show
ShowUnInstDetails show
Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir" $INSTDIR
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_StreamingAssets_Dir" "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}_Data\StreamingAssets"
  SetOverwrite ifnewer
  File /r /x "${PACK_RESOURCE_PATH_EXE_NAME}_BackUpThisFolder_ButDontShipItWithYourGame" /x "StreamingAssets" "${PACK_RESOURCE_PATH}\*.*"
SectionEnd

Section -AdditionalIcons
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  ; 让控制面板的图标与可执行程序的图标相同
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}.exe"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\uninst.exe"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

	; 删除数据文件夹和子文件
  RMDir /r "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}_Data"
	; 删除MonoBleedingEdge数据文件夹和子文件
  RMDir /r "$INSTDIR\MonoBleedingEdge"
  
	; 删除unity的exe和dll文件开始
  Delete "$INSTDIR\UnityPlayer.dll"
  
  Delete "$INSTDIR\UnityCrashHandler64.exe"
  
  Delete "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}.exe"
  
	; 删除IL2CPP生成的dll
  Delete "$INSTDIR\GameAssembly.dll"
  ; 删除unity的exe和dll文件结束
  
  ; 删除桌面快捷方式
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  DeleteRegKey /ifempty ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}"
  
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
; .onInit函数在程序打开时就会执行
Function .onInit
	# 禁止多个安装程序实例 Begin
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "mysetup") i .r1 ?e' #注意最后的?e
	Pop $R0 #保存LastError返回值
	;System::Call 'kernel32::CloseHandle(i r1) i.s' #此处不能关闭句柄，否则可以同时运行多个安装程序，注意r1 != R1,区分大小写
	StrCmp $R0 0 norun
	MessageBox MB_ICONEXCLAMATION|MB_TOPMOST "有一个安装向导已经运行！" /SD IDOK
	SetErrorLevel 4
	Quit
	# 禁止多个安装程序实例 End
	norun:
FunctionEnd

Function Pageshow
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
  ${If} $0 == ""
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
  SendMessage $0 ${WM_SETTEXT} 0 "STR:您已经安装过 ${PRODUCT_NAME} ，现在进行的覆盖安装不能更改安装目录，如果您需要更改安装目录，请先卸载已经安装的版本之后再运行此安装程序！"
  ${EndIf}
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
