; 강의록앱 윈도우 설치 프로그램 (NSIS) — 안의 install.ps1 을 창 없이 실행 (앱 파일 복사 · 파이썬 · 바로가기) → 바로 앱 화면
; 필요한 프로그램(꾸러미 · 자동 로그인 브라우저 · LibreOffice)은 앱 처음 설정에서 동의한 뒤 앱이 받음 (검은 창 없음)
Unicode true
ManifestDPIAware true
RequestExecutionLevel user
SetCompressor /SOLID lzma
!include "MUI2.nsh"
!define APPNAME "강의록앱"
Name "${APPNAME} ${VER}"
OutFile "${OUT}"
Icon "${PAY}\app\icon.ico"
!define MUI_ICON "${PAY}\app\icon.ico"
!define MUI_WELCOMEPAGE_TITLE "${APPNAME} 설치"
!define MUI_WELCOMEPAGE_TEXT "버전 ${VER}$\r$\n$\r$\n설치를 누르면 앱 파일을 복사하고 바로 강의록앱 화면을 열어요 (1분 안쪽).$\r$\n이 컴퓨터에 파이썬이 없으면 파이썬 3.12도 창 없이 같이 설치해요 (몇 분 더 걸려요).$\r$\n$\r$\n강의록을 받는 데 필요한 프로그램은 앱의 처음 설정에서 동의한 뒤에 받아요.$\r$\n$\r$\n이미 설치돼 있으면 새 버전으로 바꿔요. 받아 둔 강의록·설정은 그대로 남아요."
!define MUI_FINISHPAGE_TITLE "${APPNAME} 설치 끝"
!define MUI_FINISHPAGE_TEXT "강의록앱 화면이 열렸어요. 처음 설정을 따라가 주세요 (필요한 프로그램은 거기서 동의한 뒤 받아요).$\r$\n$\r$\n다음부터는 바탕 화면이나 시작 메뉴의 [강의록앱]으로 열어요.$\r$\n지우려면 윈도우 설정 › 앱 › 설치된 앱 › 강의록앱 (받아 둔 강의록 PDF는 남겨요 · LibreOffice · 파이썬은 다른 프로그램도 쓸 수 있어서 남아요)."
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Korean"
VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=${LANG_KOREAN} "ProductName" "${APPNAME}"
VIAddVersionKey /LANG=${LANG_KOREAN} "FileDescription" "${APPNAME} 설치"
VIAddVersionKey /LANG=${LANG_KOREAN} "ProductVersion" "${VER}"
VIAddVersionKey /LANG=${LANG_KOREAN} "FileVersion" "${VER}"
VIAddVersionKey /LANG=${LANG_KOREAN} "LegalCopyright" "© 2026 @KCM"
ShowInstDetails hide
BrandingText "${APPNAME} ${VER}"

Section "install"
  InitPluginsDir
  SetOutPath "$PLUGINSDIR\pay"
  DetailPrint "설치 파일을 푸는 중…"
  File /r "${PAY}\*.*"
  DetailPrint "앱 파일을 복사하는 중…"
  Delete "$TEMP\lectureapp_install_msg.txt"
  System::Call 'Kernel32::SetEnvironmentVariable(t "LA_HIDDEN", t "1")'
  run:
  nsExec::Exec 'powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$PLUGINSDIR\pay\install.ps1"'
  Pop $0
  StrCmp $0 "0" ok
  StrCmp $0 "2" newer
  StrCmp $0 "3" busy
    ClearErrors
    FileOpen $1 "$TEMP\lectureapp_install_msg.txt" r
    IfErrors 0 +3
      StrCpy $2 "설치 중 문제가 생겼어요 (코드 $0)."
      Goto showerr
    FileReadUTF16LE $1 $2
    FileClose $1
    showerr:
    SetOutPath "$TEMP"
    MessageBox MB_ICONEXCLAMATION "$2$\r$\n$\r$\n자세한 기록: $PROFILE\${APPNAME}\logs\설치.log"
    Abort
  busy:
    MessageBox MB_YESNO|MB_ICONQUESTION "지금 강의록을 받는 중(또는 앱이 업데이트하는 중)이에요. 설치하면 그 작업이 멈춰요.$\r$\n$\r$\n그래도 설치할까요?" IDYES force
    Abort
  force:
    System::Call 'Kernel32::SetEnvironmentVariable(t "LA_FORCE", t "1")'
    Goto run
  newer:
    MessageBox MB_ICONINFORMATION "이미 더 새 버전이 설치돼 있어요. 바탕 화면의 「강의록앱」을 눌러 열어 주세요."
    SetOutPath "$TEMP"
    Quit
  ok:
  ; 윈도우 「설치된 앱」 목록에 등록 (지우기는 앱의 삭제 과정 uninstall.ps1 그대로)
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "DisplayName" "${APPNAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "DisplayVersion" "${VER}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "Publisher" "@KCM"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "DisplayIcon" "$PROFILE\${APPNAME}\icon.ico"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "InstallLocation" "$PROFILE\${APPNAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "UninstallString" 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PROFILE\${APPNAME}\uninstall.ps1"'
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "NoModify" 1
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\LectureApp" "NoRepair" 1
SectionEnd
