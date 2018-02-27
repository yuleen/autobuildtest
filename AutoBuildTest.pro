
QT += widgets

target.path = bin
INSTALLS += target

RC_FILE = resource/resource.rc

FORMS += \
    src/mainwindow.ui

HEADERS += \
    src/mainwindow.h \
    src/version.h \
    src/build.h

SOURCES += \
    src/mainwindow.cpp \
    src/main.cpp

OTHER_FILES += \
    resource/resource.rc

