
; 從 build.ini 檔案中讀取版本資訊
#define APP_VERSION ReadIni(SourcePath+"\build.ini", "Version", "AppVersion", "0.0")
#define APP_BUILD_NO ReadIni(SourcePath+"\build.ini", "Version", "BuildNo", "0")
#define APP_COMMIT_HASH ReadIni(SourcePath+"\build.ini", "Version", "CommitHash", "")

[Setup]
AppName=AutoBuildTest
AppVersion={#APP_VERSION}_build {#APP_BUILD_NO}
VersionInfoProductVersion={#APP_VERSION}
VersionInfoVersion={#APP_VERSION}
VersionInfoCompany=InnoServ FA
VersionInfoProductName={#SetupSetting("AppName")}
DefaultDirName={sd}\{#SetupSetting("AppName")}
DefaultGroupName=InnoServFA\{#SetupSetting("AppName")}
UninstallDisplayIcon={app}\{#SetupSetting("AppName")}.exe
Compression=lzma2
SolidCompression=yes
OutputBaseFilename={#SetupSetting("AppName")}_Setup_{#SetupSetting("AppVersion")}
AlwaysRestart=yes
PrivilegesRequired=admin


[Files]
; 摰��??瑁?瑼��??賊? DLL
Source: "../bin/*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
; 撱箇?獢����?��??��??瑕?
Name: "{group}\AutoBuildTest"; Filename: "{app}\AutoBuildTest.exe"; WorkingDir: {app}
Name: "{group}\Uninstall InnoServ HMI"; Filename: "{uninstallexe}"
