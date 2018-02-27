#ifndef VERSION_H
#define VERSION_H

#include "build.h"

// APP_VERSION 由 major, minor 組合而成
// 這個版本資訊會在軟體建置的時候被賦予, 預設值是 0.0
// 如果在軟體版本畫面中看到 0.0 表示軟體不是經由正常的建置程序產生
// NOTE: 版本資訊會從版本庫的 tag 取得
#ifndef APP_VERSION_STRING
#define APP_VERSION_STRING     "0.0"
#endif

// 軟體組建號碼, 預設值是 0
// 如果在軟體版本畫面中看到 0 表示軟體不是經由正常的建置程序產生
// NOTE: 建置號碼會儲存在 buildno 檔案中, 每次建置軟體時都會自動 +1
#ifndef APP_BUILD_NO
#define APP_BUILD_NO    0
#endif


// 建置軟體時的 commit hash
// 這個 hash 可以用來追蹤 bug 是在哪個 commit 中產生的, 預設值是空白
// 軟體建置時會從版本庫中取得這個 hash
#ifndef APP_COMMIT_HASH
#define APP_COMMIT_HASH
#endif

// in TestBrach

#endif // VERSION_H
