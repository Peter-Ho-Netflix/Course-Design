#ifndef RAIDEN_SHOGUN_H
#define RAIDEN_SHOGUN_H

#include <QObject>

class Raiden_Shogun : public QObject
{
    Q_OBJECT

public:
    explicit Raiden_Shogun(QObject *parent = nullptr);

signals:

public slots:
    QString getFileName();
};

#endif // RAIDEN_SHOGUN_H
