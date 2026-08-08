#pragma once

#include <QObject>
#include "../core/MediaEngine.h"

class PlaybackController : public QObject {
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)

public:
    explicit PlaybackController(MediaEngine *engine, QObject *parent = nullptr);
    ~PlaybackController() override = default;

    [[nodiscard]] int currentIndex() const { return m_currentIndex; }
    [[nodiscard]] bool isPlaying() const { return m_isPlaying; }
    Q_INVOKABLE QString formatTime(qint64 milliseconds);
public slots:
    void playTrack(int index);
    void togglePlayPause();
    void next();
    void previous();
    void seek(qint64 position);

    signals:
        void currentIndexChanged(int index);
    void isPlayingChanged(bool isPlaying);

private:
    MediaEngine *m_engine{nullptr};
    int m_currentIndex{-1};
    bool m_isPlaying{false};
};