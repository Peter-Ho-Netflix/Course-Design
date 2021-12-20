#ifndef YOIMIYA_H
#define YOIMIYA_H

#include <QObject>
#include <QColorDialog>

class Yoimiya : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ getColor WRITE setColor NOTIFY colorChanged)
public:
    explicit Yoimiya(QObject *parent = nullptr);
    QColor getColor();
    void setColor(const QColor& color);

signals:
    void colorChanged();

public slots:
    void colorSelectorDisplay();

private:
    QColor myColor;

};

#endif // YOIMIYA_H
