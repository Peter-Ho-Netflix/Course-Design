QT += quick \
    widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        kamisato_ayaka.cpp \
        main.cpp \
        raiden_shogun.cpp \
        yoimiya.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    Graphic_Drawer_Cpp_zh_CN.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    img/eyes.svg

HEADERS += \
    kamisato_ayaka.h \
    raiden_shogun.h \
    yoimiya.h
