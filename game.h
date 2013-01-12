#ifndef GAME_H
#define GAME_H

#include <QObject>
#include "trackingSensor.h"
#include <QDebug>
#include <QtCore/QtGlobal>
#include <unistd.h>
#include <QTimer>
#include "moveable.h"
#include <QList>

class QTimer;

class Game : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TrackingSensor* trackingSensor READ trackingSensor NOTIFY trackingSensorChanged)
    Q_PROPERTY(bool trackingEnable READ trackingEnable WRITE setTrackingEnable NOTIFY trackingEnableChanged)

    Q_PROPERTY(bool gameOn READ gameOn WRITE setGameOn NOTIFY gameOnChanged)



public:
    explicit Game(QObject *parent = 0);
    ~Game();
    TrackingSensor* trackingSensor() const;
    const bool trackingEnable()const;
    bool gameOn();
    void initGame();
    //const int INTERVAL;
signals:
   void trackingSensorChanged();
   void trackingEnableChanged();
   void gameOnChanged();
public slots:
   void setTrackingEnable(const bool &newValue);
   void updateGame();
   void setGameOn(const bool &on);

private:
   TrackingSensor* m_trackingSensor;
    bool m_trackingEnable;
    bool m_gameOn;

    // some game specific
    bool m_gameOver;
    //QTimer* m_loopTimer;
};

#endif // GAME_H
