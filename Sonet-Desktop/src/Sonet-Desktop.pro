!include("../../sonet.pri"): error("Could not include file ../../sonet.pri")

DEFINES += QPM_INIT\\(E\\)=\"E.addImportPath(QStringLiteral(\\\"qrc:/\\\"));\"
include(../../qml-material/qml-material-develop/material.pri)

QT += qml quick
QT += widgets quickwidgets
QT += multimedia

CONFIG += c++11 qrc bitdht
CONFIG += link_prl

TEMPLATE = app
TARGET = Sonet-Desktop

DEPENDPATH *= Sonet-Desktop
INCLUDEPATH *= Sonet-Desktop

#################################### Windows #####################################

win32 {
        #if you want to compile borderless login window
        #just define these variables
        {
            DEFINES += BORDERLESS_LOGIN
            DEFINES += BORDERLESS_MAINWINDOW

            QT += gui-private
            LIBS += -ldwmapi

            HEADERS += \
                Bridge/Windows/qwinview.h \
                Bridge/MainWindow/mainwindow.h \
                Bridge/MainWindow/mainwindowpanel.h \
                Bridge/LoginWindow/QMainPanel.h \
                Bridge/LoginWindow/borderlesswindow.h

            SOURCES += \
                Bridge/Windows/qwinview.cpp \
                Bridge/MainWindow/mainwindow.cpp \
                Bridge/MainWindow/mainwindowpanel.cpp \
                Bridge/LoginWindow/QMainPanel.cpp \
                Bridge/LoginWindow/borderlesswindow.cpp
        }

        OBJECTS_DIR = temp/obj

        LIBS_DIR = $$PWD/../../libs/lib
        LIBS += $$OUT_PWD/../../libretroshare/src/lib/libretroshare.a
        LIBS += $$OUT_PWD/../../openpgpsdk/src/lib/libops.a

        for(lib, LIB_DIR):LIBS += -L"$$lib"
        for(bin, BIN_DIR):LIBS += -L"$$bin"


        LIBS += -lssl -lcrypto -lpthread -lminiupnpc -lz -lws2_32
        LIBS += -luuid -lole32 -liphlpapi -lcrypt32 -lgdi32
        LIBS += -lwinmm

        DEFINES *= WINDOWS_SYS WIN32_LEAN_AND_MEAN _USE_32BIT_TIME_T
}

DEPENDPATH += . ../../libretroshare/src/
INCLUDEPATH += ../../libretroshare/src/

HEADERS += libresapilocalclient.h \
    Util/runstatehelper.h \
    Util/cursorshape.h \
    Util/qquickviewhelper.h \
    Bridge/LoginWindow/loginwindow_main.h \
    Util/screensize.h

SOURCES += main.cpp \
    libresapilocalclient.cpp \
    Util/runstatehelper.cpp \
    Bridge/LoginWindow/loginwindow_main.cpp

RESOURCES += \
    GUI/MainWindow/mainwindow.qrc \
    GUI/LoginWindow/login.qrc \
    Images/images.qrc
