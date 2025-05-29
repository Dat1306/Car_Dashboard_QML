#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QTranslator>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QFileSystemWatcher>
#include <QSettings>
class LanguageManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QStringList availableLanguages READ availableLanguages NOTIFY languagesChanged)

public:
    explicit LanguageManager(QQmlApplicationEngine *engine, QObject *parent = nullptr);
    Q_INVOKABLE void changeLanguage(const QString &language);
    Q_INVOKABLE QStringList availableLanguages() const;

signals:
    void languagesChanged();

private:
    void loadAvailableLanguages();
    void setupFileWatcher();
    QSettings m_settings;

    QTranslator m_translator;
    QQmlApplicationEngine *m_engine;
    QStringList m_languages;
    QFileSystemWatcher m_watcher;
};

#endif // LANGUAGEMANAGER_H
