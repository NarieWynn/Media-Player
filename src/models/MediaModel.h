#pragma once
#include <QAbstractListModel>
#include "TrackItem.h"

class MediaModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit MediaModel(QObject *parent = nullptr);
    ~MediaModel() override = default;

    [[nodiscard]] int rowCount(const QModelIndex &parent) const override;
    [[nodiscard]] QVariant data(const QModelIndex &index, int role) const override;
    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    void addTrack(const TrackItem &track);
    void setTracks(const QList<TrackItem> &tracks);
    void clear();
    [[nodiscard]] Q_INVOKABLE TrackItem getTrack(int index) const;
    [[nodiscard]] Q_INVOKABLE QVariantMap getTrackData(int index) const;
    enum TrackRoles {
        FilePathRole = Qt::UserRole + 1,
        TitleRole,
        ArtistRole,
        AlbumRole,
        CoverArtRole,
        DurationRole,
        FormattedDurationRole
    };

private:
    QList<TrackItem> m_tracks;
};
