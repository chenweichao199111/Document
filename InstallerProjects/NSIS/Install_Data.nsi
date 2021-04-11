; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���
; Unicode is not enabled by default
; Unicode installers will not be able to run on Windows 9x!
Unicode true

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "��ɻ�"
!define PACK_RESOURCE_PATH_EXE_NAME "Star Force"
!define PRODUCT_VERSION "1.0.0.0"
!define PRODUCT_PUBLISHER "�����ƿ�ʵҵ���޹�˾"
!define PACK_RESOURCE_PATH "..\Builds"
!define INSTALL_DEFAULT_PATH "$PROGRAMFILES\${PACK_RESOURCE_PATH_EXE_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define /date CUR_YEAR "%Y"

SetCompressor /SOLID lzma
SetCompressorDictSize 32

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME

!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow

; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

;�ļ��汾����
  VIProductVersion "${PRODUCT_VERSION}"
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
  ; VIAddVersionKey /LANG=2052 "Comments" "���ʹ�ã����޷ַ���"
  VIAddVersionKey /LANG=2052 "CompanyName" "${PRODUCT_PUBLISHER}"
  ; VIAddVersionKey /LANG=2052 "LegalTrademarks" "flighty"
  VIAddVersionKey /LANG=2052 "LegalCopyright" "(C) ${CUR_YEAR} ${PRODUCT_PUBLISHER}"
  VIAddVersionKey /LANG=2052 "FileDescription" "${PRODUCT_NAME}"
  VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

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

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
; .onInit�����ڳ����ʱ�ͻ�ִ��
Function .onInit
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "myMutex") i .r1 ?e'
 	Pop $R0

 	StrCmp $R0 0 +3
   MessageBox MB_OK|MB_ICONEXCLAMATION "��װ�����Ѿ�������!"
   Abort
FunctionEnd

Function Pageshow
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}" "Install_Dir"
  ${If} $0 == ""
  MessageBox MB_ICONEXCLAMATION|MB_TOPMOST "��װ���ݰ�ǰ���밲װ������" /SD IDOK
	SetErrorLevel 4
	Quit
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
  SendMessage $0 ${WM_SETTEXT} 0 "STR:���Ѿ���װ�� ${PRODUCT_NAME} �������������ݰ�װ"
  ${EndIf}
FunctionEnd
