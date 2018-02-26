#ifndef VERSION_H
#define VERSION_H

#include "build.h"

// APP_VERSION 由 major, minor, build no. 組合而成
// 這個版本資訊會在軟體建置的時候被賦予, 預設值是 0.0.0
// 如果在軟體版本畫面中看到 0.0.0 表示軟體不是經由正常的建置程序產生
#ifndef APP_VERSION
#define APP_VERSION 0.0.0
#endif


// 建置軟體時的原始檔 ID
// 這個 ID 可以用來追蹤 bug 是在哪個 commit 中產生的, 預設值是空白
// 軟體建置時會從版本庫中取得這個 ID
#ifndef APP_COMMIT_ID
#define APP_COMMIT_ID
#endif

#endif // VERSION_H
