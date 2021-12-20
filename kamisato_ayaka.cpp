#pragma execution_character_set="utf8"
#include "kamisato_ayaka.h"
#include <QFileDialog>
#include <QDir>

Kamisato_Ayaka::Kamisato_Ayaka(QObject *parent) : QObject(parent)
{

}

QString Kamisato_Ayaka::getJSONStr()
{
    return myJSONStr;
}

QString Kamisato_Ayaka::getJSONDir()
{
    return myJSONDir;
}

void Kamisato_Ayaka::setJSONStr(const QString &jstr)
{
    myJSONStr=jstr;
    emit JSONStrChanged();
}

void Kamisato_Ayaka::setJSONDir(const QString &jdir)
{
    myJSONDir=jdir;
    emit JSONDirChanged();
}

QString Kamisato_Ayaka::nowReadJSON(const QString &filename)
{
    QFile kagFile(filename);
    assert(kagFile.open(QIODevice::ReadOnly | QIODevice::Text));
    QString jstr=kagFile.readAll();
    setJSONStr(jstr);
    kagFile.close();
    return jstr;
}

void Kamisato_Ayaka::openFileButtonClicked()
{
    QString kagFileDir=QFileDialog::getOpenFileName(nullptr, tr("打开Kamisato Ayaka Graphics文件"), "", tr("KAG文件(*.kag)"));
    readJSON(kagFileDir);
    setJSONDir(kagFileDir);
    qDebug()<<"甘雨";
}

void Kamisato_Ayaka::saveFileButtonClicked()
{
    QString kagFileDir=QFileDialog::getSaveFileName(nullptr, tr("保存文件"), "", tr("KAG文件(*.kag)"));
    saveJSON(kagFileDir);
    qDebug()<<"烟绯";
}

void Kamisato_Ayaka::saveJSON(const QString &filename)
{
    if(filename!="")
    {
        QFile kagFile(filename);
        assert(kagFile.open(QIODevice::WriteOnly | QIODevice::Text));
        kagFile.write(myJSONStr.toUtf8());
        kagFile.close();
    }
}

void Kamisato_Ayaka::readJSON(const QString& filename)
{
    QFile kagFile(filename);
    if(kagFile.open(QIODevice::ReadOnly | QIODevice::Text)){
        QString jstr=kagFile.readAll();
        setJSONStr(jstr);
        kagFile.close();
        emit readFinished();
    }
}
