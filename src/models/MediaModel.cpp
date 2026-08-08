#include "MediaModel.h"

MediaModel::MediaModel(QObject* parent) : QAbstractListModel(parent) {}

int MediaModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return m_tracks.count();
}

QVariant MediaModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 ||index.row() >= m_tracks.size()) return QVariant();
    const TrackItem &track = m_tracks[index.row()];
    switch (role) {
        case TitleRole: return track.title;
        case ArtistRole: return track.artist;
        case AlbumRole: return track.album;
        case FilePathRole: return track.filePath;
        case CoverArtRole: return track.coverArt;
        case DurationRole: return track.duration;
        case FormattedDurationRole: return track.formattedDuration();
        case IsVideoRole: return track.isVideo; // <-- BỔ SUNG: Trả về trạng thái Video
        default: return QVariant();
    }
}

QHash<int, QByteArray>  MediaModel::roleNames() const {
    QHash<int, QByteArray>  roles;
    roles[FilePathRole] = "filePath";
    roles[TitleRole] = "title";
    roles[ArtistRole] = "artist";
    roles[AlbumRole] = "album";
    roles[CoverArtRole] = "coverArt";
    roles[DurationRole] = "duration";
    roles[FormattedDurationRole] = "formattedDuration";
    roles[IsVideoRole] = "isVideo"; // <-- BỔ SUNG: Định nghĩa tên biến cho QML gọi
    return roles;
}

void MediaModel::addTrack(const TrackItem &track) {
    beginInsertRows(QModelIndex(), m_tracks.size(), m_tracks.size());
    m_tracks.append(track);
    endInsertRows();
}

void MediaModel::setTracks(const QList<TrackItem> &tracks) {
    beginResetModel();
    m_tracks = tracks;
    endResetModel();
}

void MediaModel::clear() {
    beginResetModel();
    m_tracks.clear();
    endResetModel();
}

TrackItem MediaModel::getTrack(int index) const {
    if (index < 0 || index >= m_tracks.size()) {
        return TrackItem();
    }
    return m_tracks[index];
}

QVariantMap MediaModel::getTrackData(int index) const {
    QVariantMap map;
    if (index >= 0 && index < m_tracks.size()) {
        const auto &track = m_tracks[index];
        map["filePath"] = track.filePath;
        map["title"] = track.title;
        map["artist"] = track.artist;
        map["album"] = track.album;
        map["coverArt"] = track.coverArt;
        map["duration"] = track.duration;
        map["formattedDuration"] = track.formattedDuration();
        map["isVideo"] = track.isVideo; // <-- BỔ SUNG: Đóng gói cẩn thận để PlayerView đọc
    }
    return map;
}