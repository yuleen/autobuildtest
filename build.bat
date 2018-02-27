@echo off

REM 從 remote repository 取得程式原始檔
REM 注意: 這裡限定從 master 分支取得原始檔
REM NOTE: 初期先使用 local repository 測試, 之後有建置 build server 時在從遠端 clone
git checkout master

REM 取得 repo 中的 tag, 將這個 tag 當成軟體版本
for /f %%i in ('git describe "--abbrev=0"') do set REPO_TAG=%%i
if %ERRORLEVEL% NEQ 0 (
	set REPO_TAG=Unknown
)
set APP_VERSION=%REPO_TAG%
echo %APP_VERSION%

REM 取得建置號碼, 將建置號碼加 1 之後回存
for /f %%i in ('type buildno') do set BUILD_NO=%%i
set /a BUILD_NO=%BUILD_NO%+1
set BUILD_NO=%BUILD_NO: =%
echo %BUILD_NO% > buildno

REM 將建置號碼 commit 到版本庫中
git add buildno
git commit -m "auto build Version=%REPO_TAG%, BuildNo=%BUILD_NO%"
git push origin master
if %ERRORLEVEL% NEQ 0 (
	echo Error: Push to remote repository failed
	pause
	exit /b %ERRORLEVEL%
)

REM 取得 commit hash
for /f %%i in ('git log "--pretty=format":%%h -n 1') do set COMMIT_HASH=%%i
echo %COMMIT_HASH%

REM 建立 src/build.h 檔案, 建立新的檔案之前先刪除舊的版本
set BUILD_H_FILE=src\build.h
if exist %BUILD_H_FILE% (del %BUILD_H_FILE%)
@echo #ifndef BUILD_H > %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define BUILD_H >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_VERSION_STRING "%REPO_TAG%" >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_BUILD_NO %BUILD_NO% >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #define APP_COMMIT_HASH "%COMMIT_HASH%" >> %BUILD_H_FILE%
@echo. >> %BUILD_H_FILE%
@echo #endif // BUILD_H >> %BUILD_H_FILE%

REM 開始建置程序
qmake AutoBuildTest.pro -o Makefile
mingw32-make -f Makefile clean
mingw32-make -f Makefile release
mingw32-make -f Makefile install
