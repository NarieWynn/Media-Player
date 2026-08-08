#include "PlaybackController.h"

PlaybackController::PlaybackController(MediaEngine *engine, QObject *parent)
    : QObject(parent), m_engine(engine) {

    if (m_engine && m_engine->player()) {
        connect(m_engine->player(), &MediaPlayer::playbackStateChanged, this, [this](QMediaPlayer::PlaybackState state) {
            bool playing = (state == QMediaPlayer::PlayingState);
            if (m_isPlaying != playing) {
                m_isPlaying = playing;
                emit isPlayingChanged(m_isPlaying);
            }
        });
        connect(m_engine->player(), &MediaPlayer::mediaFinished, this, &PlaybackController::next);
    }
}

void PlaybackController::playTrack(int index) {
    if (!m_engine || !m_engine->model() || index < 0 || index >= m_engine->model()->rowCount(QModelIndex())) return;

    m_currentIndex = index;
    emit currentIndexChanged(m_currentIndex);

    // Lấy thông tin bài hát từ Model ra
    QVariantMap trackData = m_engine->model()->getTrackData(index);
    QString filePath = trackData["filePath"].toString();
    bool isVideo = trackData["isVideo"].toBool(); // <-- BỚI THẰNG NÀY RA ĐỂ KIỂM TRA

    if (isVideo) {
        // NẾU LÀ MP4: Bắt Backend C++ câm mồm! Để dành đường tiếng + hình cho PlayerView QML lo.
        if (m_engine->player()) {
            m_engine->player()->pause(); // Tắt luồng audio C++
        }
        m_isPlaying = false; // Báo UI là audio backend đang nghỉ khỏe
        emit isPlayingChanged(m_isPlaying);
    } else {
        // NẾU LÀ MP3: Set đường dẫn và phát quẩy tung nóc như bình thường
        m_engine->player()->playUrl(QUrl::fromLocalFile(filePath));
        m_isPlaying = true;
        emit isPlayingChanged(m_isPlaying);
    }
}

void PlaybackController::togglePlayPause() {
    if (!m_engine || !m_engine->player()) return;

    // Check xem bài hiện tại có phải video không, nếu là video thì nút này trên backend đéo có tác dụng
    QVariantMap trackData = m_engine->model()->getTrackData(m_currentIndex);
    if (trackData["isVideo"].toBool()) {
        return;
    }

    if (m_isPlaying) {
        // Đang phát -> Ra lệnh Pause
        m_engine->player()->pause();
        m_isPlaying = false;
    } else {
        // Đang dừng -> Muốn phát tiếp
        if (m_engine->player()->duration() == 0 && m_engine->model()->rowCount(QModelIndex()) > 0) {
            playTrack(m_currentIndex >= 0 ? m_currentIndex : 0);
            return;
        } else {
            m_engine->player()->play();
            m_isPlaying = true;
        }
    }

    emit isPlayingChanged(m_isPlaying);
}

void PlaybackController::next() {
    if (!m_engine || !m_engine->model()) return;
    int total = m_engine->model()->rowCount(QModelIndex());
    if (total == 0) return;

    int nextIndex = (m_currentIndex + 1) % total;
    playTrack(nextIndex);
}

void PlaybackController::previous() {
    if (!m_engine || !m_engine->model()) return;
    int total = m_engine->model()->rowCount(QModelIndex());
    if (total == 0) return;

    int prevIndex = (m_currentIndex - 1 + total) % total;
    playTrack(prevIndex);
}

void PlaybackController::seek(qint64 position) {
    if (m_engine && m_engine->player()) {
        m_engine->player()->setPosition(position);
    }
}