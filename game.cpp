#include "game.h"

Game::Game(QObject *parent) :
    QObject(parent)
{
    m_trackingSensor = new TrackingSensor();
    connect(this->m_trackingSensor,SIGNAL(leftSensorChanged()),this,SIGNAL(trackingSensorChanged()));
    connect(this->m_trackingSensor,SIGNAL(rightSensorChanged()),this,SIGNAL(trackingSensorChanged()));
    connect(this->m_trackingSensor,SIGNAL(bottomSensorChanged()),this,SIGNAL(trackingSensorChanged()));
    m_trackingEnable = false;

    m_gameOver = false;
    m_gameOn = false;

}

Game::~Game(){
    delete m_trackingSensor;
}
void Game::initGame(){
   // for(int i=0; i<Settings::ENEMIES; i++){

        //m_enemys[i]=new MoveAble(qrand()*Settings::GAME_WIDTH, qrand()*Settings::GAME_HEIGHT);
    //}
}

void Game::updateGame(){
    qDebug() << "Hallo update";

    // move enemies
    /*for(int i=0; i<Settings::ENEMIES; i++){
        m_enemys[i]->move((qreal)1.0,(qreal)0.0);
    }*/
}


TrackingSensor* Game::trackingSensor() const{
    return m_trackingSensor;
}

const bool Game::trackingEnable()const{
    return this->m_trackingEnable;
}
void Game::setTrackingEnable(const bool &newValue){
    if (m_trackingEnable != newValue) {
        m_trackingEnable = newValue;
        if(m_trackingEnable)
            m_trackingSensor->closeConnection();
        emit trackingEnableChanged();
    }
}

bool Game::gameOn() {
    return m_gameOn;
}

void Game::setGameOn(const bool &on){
    if(on==m_gameOn)
        return;
    m_gameOn = on;
    emit gameOnChanged();
}
