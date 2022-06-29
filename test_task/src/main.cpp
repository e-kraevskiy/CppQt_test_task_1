#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

//#include "mouse_handler.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/");
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

//    MouseHandler mouse_handler_;
//    engine.rootContext()->setContextProperty("mouse_handler_",
//                                             &mouse_handler_);

    // Конексты к мудулу работы с файлами
//    QObject::connect(&file_module_, SIGNAL(setPreviousResult(int)),
//                &mouse_handler_, SLOT(setDistance(int)));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
