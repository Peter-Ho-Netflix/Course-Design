#include "yoimiya.h"

Yoimiya::Yoimiya(QObject *parent) : QObject(parent)
{

}

QColor Yoimiya::getColor()
{
    return myColor;
}

void Yoimiya::setColor(const QColor &color)
{
    myColor=color;
    emit colorChanged();
}

void Yoimiya::colorSelectorDisplay()
{
    QColor nColor=QColorDialog::getColor(Qt::white, nullptr, tr("选择颜色"));
    setColor(nColor);
}
