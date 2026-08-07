#pragma once

#include <QObject>
#include <QSettings>

class SettingsController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString scanPath READ scanPath WRITE setScanPath NOTIFY scanPathChanged)
    Q_PROPERTY(bool autoPlayOnInsert READ autoPlayOnInsert WRITE setAutoPlayOnInsert NOTIFY autoPlayOnInsertChanged)
    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged)

public:
    explicit SettingsController(QObject *parent = nullptr);
    ~SettingsController() override = default;

    [[nodiscard]] QString scanPath() const { return m_scanPath; }
    [[nodiscard]] bool autoPlayOnInsert() const { return m_autoPlayOnInsert; }
    [[nodiscard]] bool darkMode() const { return m_darkMode; }

public slots:
    void setScanPath(const QString &path);
    void setAutoPlayOnInsert(bool autoPlay);
    void setDarkMode(bool darkMode);
    void resetToDefaults();

    signals:
        void scanPathChanged(const QString &path);
    void autoPlayOnInsertChanged(bool autoPlay);
    void darkModeChanged(bool darkMode);

private:
    void loadSettings();

    QSettings m_settings{"AutoPlayerOrg", "AutoPlayer"};
    QString m_scanPath{"/media/usb"};
    bool m_autoPlayOnInsert{true};
    bool m_darkMode{true};
};