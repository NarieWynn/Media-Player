#include "MediaEngine.h"
#include <QUrl>

MediaEngine::MediaEngine(QObject *parent) : QObject(parent) {
    m_scanner = new UsbScanner(this);
    m_player = new MediaPlayer(this);
    m_model = new MediaModel(this);

    // Tự động đấu nối: Scanner quét ra bài nào -> Ném ngay vào Model bài đó
    connect(m_scanner, &UsbScanner::trackFound, m_model, &MediaModel::addTrack);

}

void MediaEngine::startScan(const QString &path) {
    m_scanner->scanDirectory(path);
}

void MediaEngine::playTrackIndex(int index) {
    // Lấy thông tin bài hát từ Model dựa trên vị trí index
    TrackItem track = m_model->getTrack(index);

    if (!track.filePath.isEmpty()) {
        // Chuyển đường dẫn file máy tính thành QUrl chuẩn để MediaPlayer phát
        QUrl url = QUrl::fromLocalFile(track.filePath);
        m_player->playUrl(url);
    }
}