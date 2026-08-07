#include "SettingsController.h"

SettingsController::SettingsController(QObject *parent) : QObject(parent) {
    loadSettings();
}

void SettingsController::loadSettings() {
    m_scanPath = m_settings.value("scanPath", "/media/usb").toString();
    m_autoPlayOnInsert = m_settings.value("autoPlayOnInsert", true).toBool();
    m_darkMode = m_settings.value("darkMode", true).toBool();
}

void SettingsController::setScanPath(const QString &path) {
    if (m_scanPath != path) {
        m_scanPath = path;
        m_settings.setValue("scanPath", m_scanPath);
        emit scanPathChanged(m_scanPath);
    }
}

void SettingsController::setAutoPlayOnInsert(bool autoPlay) {
    if (m_autoPlayOnInsert != autoPlay) {
        m_autoPlayOnInsert = autoPlay;
        m_settings.setValue("autoPlayOnInsert", m_autoPlayOnInsert);
        emit autoPlayOnInsertChanged(m_autoPlayOnInsert);
    }
}

void SettingsController::setDarkMode(bool darkMode) {
    if (m_darkMode != darkMode) {
        m_darkMode = darkMode;
        m_settings.setValue("darkMode", m_darkMode);
        emit darkModeChanged(m_darkMode);
    }
}

void SettingsController::resetToDefaults() {
    setScanPath("/media/usb");
    setAutoPlayOnInsert(true);
    setDarkMode(true);
}