#pragma once
#include <QObject>
#include "../models/TrackItem.h"
class UsbScanner: public QObject {
    Q_OBJECT

public:
    explicit UsbScanner(QObject *parent = nullptr);
    ~UsbScanner() override = default;

signals:
    void trackFound(const TrackItem &track);
    void scanFinished();

public slots:
    void scanDirectory(const QString &path);
private:
};