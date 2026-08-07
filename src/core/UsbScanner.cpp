#include "UsbScanner.h"
#include <QDirIterator>
#include <QFileInfo>

UsbScanner::UsbScanner(QObject *parent) : QObject(parent) {}

void UsbScanner::scanDirectory(const QString &path) {
    QStringList filters = {"*.mp3", "*.wav", "*.flac", "*.mp4", "*.mkv", "*.avi"};
    QDirIterator it(path, filters, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        it.next();
        QFileInfo fileInfo = it.fileInfo();

        TrackItem track;
        track.filePath = fileInfo.absoluteFilePath();
        track.title = fileInfo.completeBaseName();
        track.artist = "Unknown Artist";
        track.album = "Unknown Album";
        track.coverArt = "Unknown Cover Art";
        track.duration = 0;

        emit trackFound(track);
    }
    emit scanFinished();
}