
@echo off

REM 從 remote repository 取得程式原始檔
REM 注意: 這裡限定從 master 分支取得原始檔
REM NOTE: 初期先使用 local repository 測試, 之後有建置 build server 時在從遠端 clone
git checkout master
if %ERRORLEVEL% NEQ 0 (
	echo Error: Checkout branch master failed
	pause
	exit /b %ERRORLEVEL%
)

REM 取得 repo 中的 tag, 將這個 tag 當成軟體版本
for /f %%i in ('git describe "--abbrev=0"') do set REPO_TAG=%%i
if %ERRORLEVEL% NEQ 0 (
	set REPO_TAG=0.0
)
if [%REPO_TAG%] == [] (
	set REPO_TAG=0.0
)
set APP_VERSION=%REPO_TAG%
echo APP_VERSION=%APP_VERSION%

REM 取得建置號碼, 將建置號碼加 1 之後回存
for /f %%i in ('type buildno') do set BUILD_NO=%%i
set /a BUILD_NO=%BUILD_NO%+1
set BUILD_NO=%BUILD_NO: =%
echo %BUILD_NO% > buildno

REM 將建置號碼 commit 到版本庫中
REM NOTE: 先不要 push 到 remote repository, 等之後建置 build server 後再 push 到 remote
git add buildno
git commit -m "auto build Version=%APP_VERSION%, BuildNo=%BUILD_NO%"
REM git push origin master
REM if %ERRORLEVEL% NEQ 0 (
REM 	echo Error: Push to remote repository failed
REM 	pause
REM 	exit /b %ERRORLEVEL%
REM )

REM 取得 commit hash
for /f %%i in ('git log "--pretty=format":%%h -n 1') do set COMMIT_HASH=%%i
echo %COMMIT_HASH%

REM 建立軟體版本資訊 src/build.h 檔案, 建立新的檔案之前先刪除舊的版本
set BUILD_H_FILE=src\build.h
if exist %BUILD_H_FILE% (del %BUILD_H_FILE%)
@echo #ifndef BUILD_H > %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define BUILD_H >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_VERSION_STRING "%APP_VERSION%" >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_BUILD_NO %BUILD_NO% >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_COMMIT_HASH "%COMMIT_HASH%" >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #endif // BUILD_H >> %BUILD_H_FILE%

REM 建立資源檔版本資訊 resource/resource_version.h 檔案, 建立新的檔案之前先刪除舊的版本
set RESOURCE_H_FILE=resource\resource_version.h
if exist %RESOURCE_H_FILE% (del %RESOURCE_H_FILE%)
@echo #define APP_VERSION "%APP_VERSION%" > %RESOURCE_H_FILE%
@echo #define APP_BUILD_NO "%BUILD_NO%" >> %RESOURCE_H_FILE%
@echo #define APP_COMMIT_HASH "%COMMIT_HASH%" >> %RESOURCE_H_FILE%

REM 開始建置程序, 建置之前先 uninstall 刪除先前已經 install 過的檔案, 避免版本衝突
qmake AutoBuildTest.pro -o Makefile
mingw32-make -f Makefile uninstall
mingw32-make -f Makefile clean
mingw32-make -f Makefile release
mingw32-make -f Makefile install

REM 建置完成之後回復 src/build.h 和 resource/resource_version.h
REM 避免不小心將新的 build.h 和 resource_version.h commit 到版本庫
git checkout %BUILD_H_FILE%
git checkout %RESOURCE_H_FILE%

REM 產生安裝檔
set BUILD_INI_FILE=InnoSetup\build.ini
set INNOSETUP_ISS_FILE=InnoSetup\AutoBuildTest_setup.iss
if exist %BUILD_INI_FILE% (del %BUILD_INI_FILE%)
@echo [Version] > %BUILD_INI_FILE%
@echo AppVersion=%APP_VERSION% >> %BUILD_INI_FILE%
@echo BuildNo=%BUILD_NO% >> %BUILD_INI_FILE%
@echo CommitHash=%COMMIT_HASH% >> %BUILD_INI_FILE%
iscc "%INNOSETUP_ISS_FILE%"

REM 安裝檔產生之後回復 InnoSetup/build.ini 檔案
REM 避免不小心將新的 build.ini commit 到版本庫
git checkout %BUILD_INI_FILE%

echo Success: Build complete
pause
