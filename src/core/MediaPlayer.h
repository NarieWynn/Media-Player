#pragma once
#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QUrl>

class MediaPlayer : public QObject {
    Q_OBJECT
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)

public:
    explicit MediaPlayer(QObject *parent = nullptr);
    ~MediaPlayer() override = default;
    [[nodiscard]] Q_INVOKABLE float volume() const { return m_volume; }
    [[nodiscard]] qint64 position() const { return m_position; }
    [[nodiscard]] qint64 duration() const { return m_duration; }

public slots:
    void play();
    void playUrl(const QUrl &url);
    void pause();
    void stop();
    void setPosition(qint64 position);
    Q_INVOKABLE void setVolume(float volume);

    void seek(qint64 position);
    void setMute(bool mute);
    void setSpeed(float speed);
    void setLoop(bool loop);

signals:
    void positionChanged(qint64 position);
    void durationChanged(qint64 duration);
    void playbackStateChanged(QMediaPlayer::PlaybackState state);
    void volumeChanged(float volume);
    void mediaFinished();
private:
    QMediaPlayer *m_player{nullptr};
    QAudioOutput *m_audioOutput{nullptr};
    float m_volume{0.5f};
    qint64 m_position{0};
    qint64 m_duration{0};
};