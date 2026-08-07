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
    }
}

void PlaybackController::playTrack(int index) {
    if (!m_engine || !m_engine->model() || index < 0 || index >= m_engine->model()->rowCount(QModelIndex())) return;

    m_currentIndex = index;
    emit currentIndexChanged(m_currentIndex);

    // Lấy URL bài hát từ Model ra và phát
    QVariantMap trackData = m_engine->model()->getTrackData(index);
    QString filePath = trackData["filePath"].toString();
    m_engine->player()->playUrl(QUrl::fromLocalFile(filePath));

    // ======== 2 DÒNG QUAN TRỌNG VỪA THÊM VÀO ========
    // Bắt buộc cập nhật biến isPlaying và bắn pháo sáng báo cho QML biết để đổi icon!
    m_isPlaying = true;
    emit isPlayingChanged(m_isPlaying);
}

void PlaybackController::togglePlayPause() {
    if (!m_engine || !m_engine->player()) return;

    if (m_isPlaying) {
        // Đang phát -> Ra lệnh Pause
        m_engine->player()->pause();
        m_isPlaying = false;
    } else {
        // Đang dừng -> Muốn phát tiếp

        // KIỂM TRA ĐIỀU KIỆN 1: Mới mở app (Chưa có bài nào được nạp, duration = 0)
        if (m_engine->player()->duration() == 0 && m_engine->model()->rowCount(QModelIndex()) > 0) {
            // Ép nó load thẳng bài hát đầu tiên trong danh sách USB
            playTrack(m_currentIndex >= 0 ? m_currentIndex : 0);
            return; // Đã gọi playTrack thì nó tự xử lý isPlaying rồi, thoát luôn!
        }
        // KIỂM TRA ĐIỀU KIỆN 2: Đã có bài hát đang tạm dừng
        else {
            // Chỉ việc gọi hàm play() (Resume) vừa tạo ở Bước 1
            m_engine->player()->play();
            m_isPlaying = true;
        }
    }

    // Bắn tín hiệu lên QML để đổi icon nút bấm
    emit isPlayingChanged(m_isPlaying);
}

void PlaybackController::next() {
    if (!m_engine || !m_engine->model()) return;
    int total = m_engine->model()->rowCount(QModelIndex());
    if (total == 0) return;

    int nextIndex = (m_currentIndex + 1) % total; // Xoay vòng về bài đầu khi hết danh sách
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