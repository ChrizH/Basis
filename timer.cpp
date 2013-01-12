#include "timer.h"
#include <QTimer>
#include <QDebug>
Timer::Timer(QObject *parent) :
    QObject(parent),
    m_timer(new QTimer(this))
{
    connect( m_timer, SIGNAL( timeout() ), this, SIGNAL( timeout() ) );
}

Timer::~Timer(){
    delete m_timer;
}


void Timer::setInterval( int msec )
{
    if ( m_timer->interval() == msec )
        return;
    m_timer->stop();
    m_timer->setInterval( msec );
    m_timer->start();
    emit intervalChanged();
    qDebug() << Q_FUNC_INFO << "interval =" << m_timer->interval();
}

int Timer::interval()
{
    return m_timer->interval();
}

void Timer::setTimerOn(bool &on){
    if(m_timerOn==on)
        return;
    m_timerOn = on;

    if(m_timerOn == true)
        m_timer->start();
    else
        m_timer->stop();

    emit timerOnChanged();
}

bool Timer::timerOn(){
    return m_timerOn;
}
