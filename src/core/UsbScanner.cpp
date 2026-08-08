#include "UsbScanner.h"
#include <QDirIterator>
#include <QFileInfo>
#ifndef Q_OS_ANDROID
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#endif
#include <QDir>
#include <QStandardPaths>
#include <QPainter>
#include <QUrl>

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
        track.coverArt = "";

        // 1. PHÂN LOẠI FILE AUDIO HAY VIDEO
        QString ext = fileInfo.suffix().toLower();
        track.isVideo = (ext == "mp4" || ext == "mkv" || ext == "avi");

        // 2. BÓC THỜI LƯỢNG (Chỉ dùng TagLib trên Linux/Windows)
        track.duration = 0; // Android tạm thời gán 0
#ifndef Q_OS_ANDROID
        TagLib::FileRef f(track.filePath.toUtf8().constData());
        if (!f.isNull() && f.audioProperties()) {
            track.duration = f.audioProperties()->lengthInMilliseconds();
        }
#endif

        // 3. BÓC METADATA & COVER ART (Cũng bọc lại đéo cho Android chạy)
        if (ext == "mp3") {
#ifndef Q_OS_ANDROID
            TagLib::MPEG::File mpegFile(track.filePath.toUtf8().constData());

            if (mpegFile.isValid()) {
                if (mpegFile.tag()) {
                    TagLib::Tag *tag = mpegFile.tag();
                    QString artistStr = QString::fromUtf8(tag->artist().toCString(true)).trimmed();
                    QString albumStr = QString::fromUtf8(tag->album().toCString(true)).trimmed();
                    QString titleStr = QString::fromUtf8(tag->title().toCString(true)).trimmed();

                    if (!artistStr.isEmpty()) track.artist = artistStr;
                    if (!albumStr.isEmpty()) track.album = albumStr;
                    if (!titleStr.isEmpty()) track.title = titleStr;
                }

                if (mpegFile.ID3v2Tag()) {
                    TagLib::ID3v2::Tag *id3v2 = mpegFile.ID3v2Tag();
                    TagLib::ID3v2::FrameList frameList = id3v2->frameList("APIC");

                    if (!frameList.isEmpty()) {
                        auto *frame = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame*>(frameList.front());
                        if (frame) {
                            QString cacheDir = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/covers";
                            QDir().mkpath(cacheDir);

                            QImage srcImg;
                            srcImg.loadFromData(reinterpret_cast<const uchar*>(frame->picture().data()), frame->picture().size());

                            if (!srcImg.isNull()) {
                                int w = srcImg.width();
                                int h = srcImg.height();
                                int side = qMin(w, h);
                                int cropSize = side * 0.85;

                                int x = (w - cropSize) / 2;
                                int y = (h - cropSize) / 2;

                                QImage cropped = srcImg.copy(x, y, cropSize, cropSize);

                                QImage roundedImg(cropSize, cropSize, QImage::Format_ARGB32);
                                roundedImg.fill(Qt::transparent);

                                QPainter painter(&roundedImg);
                                painter.setRenderHint(QPainter::Antialiasing, true);
                                painter.setRenderHint(QPainter::SmoothPixmapTransform, true);
                                painter.setBrush(QBrush(cropped.scaled(cropSize, cropSize, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)));
                                painter.setPen(Qt::NoPen);
                                painter.drawEllipse(0, 0, cropSize, cropSize);
                                painter.end();

                                QString coverPath = cacheDir + "/" + fileInfo.completeBaseName() + ".png";
                                if (roundedImg.save(coverPath, "PNG")) {
                                    track.coverArt = QUrl::fromLocalFile(coverPath).toString();
                                }
                            }
                        }
                    }
                }
            }
#endif
        }

        // 4. FALLBACK TÊN CA SĨ
        if (track.artist == "Unknown Artist" || track.artist.isEmpty()) {
            QString baseName = fileInfo.completeBaseName();
            if (baseName.contains(" - ")) {
                QStringList parts = baseName.split(" - ");
                track.artist = parts.at(0).trimmed();
                track.title = parts.at(1).trimmed();
            }
        }

        emit trackFound(track);
    }

    emit scanFinished();
}