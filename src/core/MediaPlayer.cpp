#include "MediaPlayer.h"

MediaPlayer::MediaPlayer(QObject *parent) : QObject(parent) {
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);

    connect(m_player, &QMediaPlayer::positionChanged, this, [this](qint64 pos) {
        m_position = pos;
        emit positionChanged(pos);
    });

    connect(m_player, &QMediaPlayer::durationChanged, this, [this](qint64 dur) {
        m_duration = dur;
        emit durationChanged(dur);
    });
}

void MediaPlayer::playUrl(const QUrl &url) {
    if (m_player->source() != url) {
        m_player->setSource(url);
    }
    m_player->play();
}

void MediaPlayer::play() {
    m_player->play();
}

void MediaPlayer::pause() {
    m_player->pause();
}

void MediaPlayer::stop() {
    m_player->stop();
}

void MediaPlayer::setPosition(qint64 position) {
    m_player->setPosition(position);
}

void MediaPlayer::setVolume(float volume) {

    m_audioOutput->setVolume(volume);
}
void MediaPlayer::seek(qint64 position) {
    // Bản chất seek với setPosition là một, gọi lại cho gọn
    m_player->setPosition(position);
}

void MediaPlayer::setMute(bool mute) {
    m_audioOutput->setMuted(mute);
}

void MediaPlayer::setSpeed(float speed) {
    // Chỉnh tốc độ phát (1.0f là bình thường, 1.5f là nhanh 1.5 lần)
    m_player->setPlaybackRate(speed);
}

void MediaPlayer::setLoop(bool loop) {
    // Qt6 dùng QMediaPlayer::Loops để chỉnh lặp
    m_player->setLoops(loop ? QMediaPlayer::Infinite : QMediaPlayer::Once);
}


