#pragma once
#include <QString>

struct TrackItem {
    QString filePath;
    QString title;
    QString artist;
    QString album;
    QString coverArt;
    qint64 duration = 0;
    bool isVideo = false;

    [[nodiscard]] QString formattedDuration() const {
        qint64 totalSeconds = duration / 1000;
        int minutes = static_cast<int>(totalSeconds / 60);
        int seconds = static_cast<int>(totalSeconds % 60);

        // Trả về chuỗi dạng "03:45"
        return QString("%1:%2")
            .arg(minutes, 2, 10, QChar('0'))
            .arg(seconds, 2, 10, QChar('0'));
    }
};