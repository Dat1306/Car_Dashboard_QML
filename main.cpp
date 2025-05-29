#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "LanguageManager.h"
#include <QIcon>
int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/assets/images/icon_car.png"));

    QQmlApplicationEngine engine;

    LanguageManager langManager(&engine);
    engine.rootContext()->setContextProperty("langManager", &langManager);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
