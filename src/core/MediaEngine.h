#pragma once
#include <QObject>
#include "UsbScanner.h"
#include "MediaPlayer.h"
#include "../models/MediaModel.h"

class MediaEngine : public QObject {
    Q_OBJECT

public:
    explicit MediaEngine(QObject *parent = nullptr);
    ~MediaEngine() override = default;

    [[nodiscard]] MediaModel* model() const { return m_model; }
    [[nodiscard]] Q_INVOKABLE MediaPlayer* player() const { return m_player; }

public slots:
    void startScan(const QString &path);
    void playTrackIndex(int index);

private:
    UsbScanner *m_scanner{nullptr};
    MediaPlayer *m_player{nullptr};
    MediaModel *m_model{nullptr};
};