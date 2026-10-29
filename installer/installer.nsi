; 강의록앱 윈도우 설치 프로그램 (NSIS) — 안의 install.ps1 을 그대로 실행 (설치 위치·과정은 zip의 설치.bat 과 같음)
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
!define MUI_WELCOMEPAGE_TEXT "버전 ${VER}$\r$\n$\r$\n설치를 누르면 검은 설치 창이 뜨고 필요한 프로그램(파이썬, 자동 로그인 브라우저, LibreOffice)을 준비해요. 처음엔 5~10분 걸릴 수 있어요.$\r$\n$\r$\n이미 설치돼 있으면 새 버전으로 바꿔요. 받아 둔 강의록·설정은 그대로 남아요."
!define MUI_FINISHPAGE_TITLE "${APPNAME} 설치 끝"
!define MUI_FINISHPAGE_TEXT "앱 화면이 열렸어요. 처음 설정을 따라가 주세요.$\r$\n$\r$\n다음부터는 바탕 화면이나 시작 메뉴의 [강의록앱]으로 열어요.$\r$\n지우려면 윈도우 설정 › 앱 › 설치된 앱 › 강의록앱 (받아 둔 강의록 PDF는 남겨요)."
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
ShowInstDetails show
BrandingText "${APPNAME} ${VER}"

Section "install"
  InitPluginsDir
  SetOutPath "$PLUGINSDIR\pay"
  DetailPrint "설치 파일을 푸는 중…"
  File /r "${PAY}\*.*"
  DetailPrint "검은 설치 창에서 설치하는 중이에요. 창이 닫힐 때까지 기다려 주세요."
  ExecWait 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PLUGINSDIR\pay\install.ps1"' $0
  SetOutPath "$TEMP"
  StrCmp $0 "0" ok
    MessageBox MB_ICONEXCLAMATION "설치가 끝나지 않았어요 (코드 $0). 검은 창의 안내를 확인하고 다시 실행해 주세요."
    Abort
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
