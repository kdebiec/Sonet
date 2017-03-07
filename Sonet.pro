!include("sonet.pri"): error("Could not include file sonet.pri")

INCLUDEPATH += $$PWD/Build/libs/include
DEPENDPATH += $$PWD/Build/libs/include

TEMPLATE = subdirs

CONFIG+= static

SUBDIRS += openpgpsdk
openpgpsdk.file = openpgpsdk/src/openpgpsdk.pro

SUBDIRS += libbitdht
libbitdht.file = libbitdht/src/libbitdht.pro

SUBDIRS += libretroshare
libretroshare.file = libretroshare/src/libretroshare.pro
libretroshare.depends = openpgpsdk libbitdht

SUBDIRS += libresapi
libresapi.file = libresapi/src/libresapi.pro
libresapi.depends = libretroshare

retroshare_android_service {
    SUBDIRS += retroshare_android_service
    retroshare_android_service.file = retroshare-android-service/src/retroshare-android-service.pro
    retroshare_android_service.depends = libretroshare libresapi
    retroshare_android_service.target = retroshare_android_service
}

Sonet-Desktop {
    SUBDIRS += Sonet-Desktop
    Sonet-Desktop.file = Sonet-Desktop/src/Sonet-Desktop.pro
    Sonet-Desktop.depends = libretroshare retroshare_android_service
    Sonet-Desktop.target = Sonet-Desktop
}
