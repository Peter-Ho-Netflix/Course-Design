#include "raiden_shogun.h"
#include <QFileDialog>

Raiden_Shogun::Raiden_Shogun(QObject *parent) : QObject(parent)
{

}

QString Raiden_Shogun::getFileName()
{
    QString getname=QFileDialog::getSaveFileName(nullptr, "导出到", "", "BMP文件(*.bmp)");
    return getname;
}
