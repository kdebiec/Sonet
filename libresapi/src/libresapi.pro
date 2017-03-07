!include("../../sonet.pri"): error("Could not include file ../../sonet.pri")

TEMPLATE = lib
CONFIG += c++11
CONFIG += staticlib libresapilocalserver
#CONFIG += create_prl
CONFIG += link_prl
#CONFIG -= qt
TARGET = resapi
TARGET_PRL = libresapi
DESTDIR = lib

win32 {
        OBJECTS_DIR = temp/obj

        LIBS_DIR = $$PWD/../../libs/lib
        LIBS += $$OUT_PWD/../../libretroshare/src/lib/libretroshare.a
        LIBS += $$OUT_PWD/../../openpgpsdk/src/lib/libops.a

        for(lib, LIB_DIR):LIBS += -L"$$lib"
        for(bin, BIN_DIR):LIBS += -L"$$bin"


        LIBS += -lssl -lcrypto -lpthread -lminiupnpc -lz -lws2_32
        LIBS += -luuid -lole32 -liphlpapi -lcrypt32 -lgdi32
        LIBS += -lwinmm
        LIBS += -lopus
        #LIBS += -lspeex -lspeexdsp

        DEFINES *= WINDOWS_SYS WIN32_LEAN_AND_MEAN _USE_32BIT_TIME_T

        DEPENDPATH += . $$INC_DIR
        INCLUDEPATH += . $$INC_DIR

        greaterThan(QT_MAJOR_VERSION, 4) {
                # Qt 5
                RC_INCLUDEPATH += $$_PRO_FILE_PWD_/../../libretroshare/src
        } else {
                # Qt 4
                QMAKE_RC += --include-dir=$$_PRO_FILE_PWD_/../../libretroshare/src
        }
}

DEPENDPATH += . ../../libretroshare/src/
INCLUDEPATH += ../../libretroshare/src/

SOURCES += \
	api/ApiServer.cpp \
	api/json.cpp \
	api/JsonStream.cpp \
	api/ResourceRouter.cpp \
	api/PeersHandler.cpp \
	api/Operators.cpp \
	api/IdentityHandler.cpp \
	api/ForumHandler.cpp \
	api/ServiceControlHandler.cpp \
	api/StateTokenServer.cpp \
	api/GxsResponseTask.cpp \
	api/FileSearchHandler.cpp \
	api/TransfersHandler.cpp	\
	api/RsControlModule.cpp	\
	api/GetPluginInterfaces.cpp \
    api/ChatHandler.cpp \
    api/LivereloadHandler.cpp \
    api/TmpBlobStore.cpp \
    util/ContentTypes.cpp \
    api/ApiPluginHandler.cpp \
    api/ChannelsHandler.cpp \
    api/StatsHandler.cpp \
    api/SettingsHandler.cpp

HEADERS += \
	api/ApiServer.h \
	api/json.h \
	api/JsonStream.h \
	api/ApiTypes.h \
	api/ResourceRouter.h \
	api/PeersHandler.h \
	api/Operators.h \
	api/IdentityHandler.h \
	api/ForumHandler.h \
	api/ServiceControlHandler.h \
	api/GxsMetaOperators.h \
	api/StateTokenServer.h \
	api/GxsResponseTask.h \
	api/Pagination.h \
	api/FileSearchHandler.h \
	api/TransfersHandler.h	\
	api/RsControlModule.h	\
	api/GetPluginInterfaces.h \
    api/ChatHandler.h \
    api/LivereloadHandler.h \
    api/TmpBlobStore.h \
    util/ContentTypes.h \
    api/ApiPluginHandler.h \
    api/ChannelsHandler.h \
    api/StatsHandler.h \
    api/SettingsHandler.h

libresapilocalserver {
    CONFIG *= qt
    QT *= network
    SOURCES *= api/ApiServerLocal.cpp
    HEADERS *= api/ApiServerLocal.h
}
