#ifndef TIMER_H
#define TIMER_H

#include <QObject>

class QTimer;

class Timer : public QObject
{
    Q_OBJECT
    Q_PROPERTY( int interval READ interval WRITE setInterval NOTIFY intervalChanged )
    Q_PROPERTY( bool timerOn READ timerOn WRITE setTimerOn NOTIFY timerOnChanged)
public:
    explicit Timer( QObject* parent = 0 );
    ~Timer();
    void setInterval( int msec );
    int interval();
    void setTimerOn(bool &on);
    bool timerOn();
signals:
    void timeout();
    void intervalChanged();
    void timerOnChanged();
    
private:
    QTimer* m_timer;
    bool m_timerOn;
};

#endif // TIMER_H
