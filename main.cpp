#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include "kamisato_ayaka.h"
#include "yoimiya.h"
#include "raiden_shogun.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "Graphic_Drawer_Cpp_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
//注册组件
    qmlRegisterType<Kamisato_Ayaka>("Kamisato_Ayaka", 2, 12, "Kamisato_Ayaka");
    qmlRegisterType<Yoimiya>("Yoimiya", 2, 12, "Yoimiya");
    qmlRegisterType<Raiden_Shogun>("Raiden_Shogun", 2, 15, "Raiden_Shogun");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
