QT      += core gui sql

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET   = qgroupingproxy-test
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += main.cpp\
           mainwindow.cpp \
    qgroupingproxymodel.cpp

HEADERS += mainwindow.h \
    qgroupingproxymodel.h

FORMS   += mainwindow.ui

RESOURCES += \
    qgroupingproxy-test.qrc

DISTFILES +=
