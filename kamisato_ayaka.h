#ifndef KAMISATO_AYAKA_H
#define KAMISATO_AYAKA_H

#include <QObject>
#include <QQuickItem>

class Kamisato_Ayaka : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString jSONStr READ getJSONStr WRITE setJSONStr NOTIFY JSONStrChanged)
    Q_PROPERTY(QString jSONDir READ getJSONDir WRITE setJSONDir NOTIFY JSONDirChanged)
public:
    explicit Kamisato_Ayaka(QObject *parent = nullptr);
    QString getJSONStr();
    QString getJSONDir();
    void setJSONStr(const QString& jstr);
    void setJSONDir(const QString& jdir);
    Q_INVOKABLE QString nowReadJSON(const QString& filename="神里绫华.kag");
signals:
    void JSONStrChanged();
    void JSONDirChanged();
    void readFinished();
public slots:
    void openFileButtonClicked();
    void saveFileButtonClicked();
    void saveJSON(const QString& filename="神里绫华.kag");
    void readJSON(const QString& filename="神里绫华.kag");
private:
    QString myJSONStr;
    QString myJSONDir;
};

#endif // KAMISATO_AYAKA_H
