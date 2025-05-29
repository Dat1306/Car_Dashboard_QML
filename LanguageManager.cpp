#include "LanguageManager.h"
#include <QCoreApplication>
#include <QDebug>

LanguageManager::LanguageManager(QQmlApplicationEngine *engine, QObject *parent)
    : QObject(parent), m_engine(engine) {
    loadAvailableLanguages();
    setupFileWatcher();
}

void LanguageManager::loadAvailableLanguages() {
    QDir dir(QCoreApplication::applicationDirPath() + "/../../translations");
    if (!dir.exists()) {
        qDebug() << "Translations directory not found:" << dir.absolutePath();
        return;
    }

    QStringList files = dir.entryList(QStringList("*.qm"), QDir::Files);
    if (files.isEmpty()) {
        qDebug() << "No translation files found in" << dir.absolutePath();
    }

    m_languages.clear();
    for (const QString &file : files) {
        QString lang = file.section('_', 1, 1).section('.', 0, 0);
        m_languages.append(lang);
    }

    qDebug() << "Updated languages list:" << m_languages;
    emit languagesChanged();
}

QStringList LanguageManager::availableLanguages() const {
    return m_languages;
}

void LanguageManager::changeLanguage(const QString &language) {
    QString qmFile = QCoreApplication::applicationDirPath() + "/../../translations/translations_" + language + ".qm";

    if (m_translator.load(qmFile)) {
        qApp->installTranslator(&m_translator);
        QMetaObject::invokeMethod(m_engine, "retranslate");
        qDebug() << "Language changed to:" << language;
        m_settings.setValue("language", language);
    } else {
        qDebug() << "Failed to load translation:" << qmFile;
    }
}


void LanguageManager::setupFileWatcher() {
    QDir dir(QCoreApplication::applicationDirPath() + "/../../translations");
    if (dir.exists()) {
        m_watcher.addPath(dir.absolutePath());
        connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, [this]() {
            qDebug() << "Translations directory changed, reloading languages...";
            loadAvailableLanguages();
        });
    }
}
