; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���
; Unicode is not enabled by default
; Unicode installers will not be able to run on Windows 9x!
Unicode true

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "��ɻ�"
!define PACK_RESOURCE_PATH_EXE_NAME "Star Force"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "�����ƿ�ʵҵ���޹�˾"
!define PRODUCT_WEB_SITE "http://www.kmax-arvr.com/"
!define PACK_RESOURCE_PATH "..\Builds"
!define INSTALL_DEFAULT_PATH "$PROGRAMFILES\${PACK_RESOURCE_PATH_EXE_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow

; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}_Full"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}_Full.exe"
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
  File /r /x "${PACK_RESOURCE_PATH_EXE_NAME}_BackUpThisFolder_ButDontShipItWithYourGame" "${PACK_RESOURCE_PATH}\*.*"
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
  ; �ÿ�������ͼ�����ִ�г����ͼ����ͬ
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}.exe"
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\uninst.exe"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

	; ɾ�������ļ��к����ļ�
  RMDir /r "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}_Data"
	; ɾ��MonoBleedingEdge�����ļ��к����ļ�
  RMDir /r "$INSTDIR\MonoBleedingEdge"
  
	; ɾ��unity��exe��dll�ļ���ʼ
  Delete "$INSTDIR\UnityPlayer.dll"
  
  Delete "$INSTDIR\UnityCrashHandler64.exe"
  
  Delete "$INSTDIR\${PACK_RESOURCE_PATH_EXE_NAME}.exe"
  
	; ɾ��IL2CPP���ɵ�dll
  Delete "$INSTDIR\GameAssembly.dll"
  ; ɾ��unity��exe��dll�ļ�����
  
  ; ɾ�������ݷ�ʽ
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  DeleteRegKey /ifempty ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}"
  
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
; .onInit�����ڳ����ʱ�ͻ�ִ��
Function .onInit
	# ��ֹ�����װ����ʵ�� Begin
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "mysetup") i .r1 ?e' #ע������?e
	Pop $R0 #����LastError����ֵ
	;System::Call 'kernel32::CloseHandle(i r1) i.s' #�˴����ܹرվ�����������ͬʱ���ж����װ����ע��r1 != R1,���ִ�Сд
	StrCmp $R0 0 norun
	MessageBox MB_ICONEXCLAMATION|MB_TOPMOST "��һ����װ���Ѿ����У�" /SD IDOK
	SetErrorLevel 4
	Quit
	# ��ֹ�����װ����ʵ�� End
	norun:
FunctionEnd

Function Pageshow
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
  ${If} $0 == ""
  ${Else}
  ;���������ť
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1001
  EnableWindow $0 0
  ;���ñ༭��Ŀ¼
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1019
  EnableWindow $0 0
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1006
  SendMessage $0 ${WM_SETTEXT} 0 "STR:���Ѿ���װ�� ${PRODUCT_NAME} �����ڽ��еĸ��ǰ�װ���ܸ��İ�װĿ¼���������Ҫ���İ�װĿ¼������ж���Ѿ���װ�İ汾֮�������д˰�װ����"
  ${EndIf}
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
