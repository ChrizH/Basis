#include "trackingSensor.h"
const qint32 baudrate = 115200;
#include <math.h>

TrackingSensor::TrackingSensor(QObject *parent)
    :QObject(parent)
{
    //qDebug() << "CTO TrackingSensor";
    m_left = 0;
    m_bottom = 0;
    m_right = 0;
    this->m_sensorValue = "Default";
    // calibrate sensor
    //qDebug() << "Calibrate the sensors now";
    m_comPortAvailable = false;
    m_connectionAvailable = false;
    m_sensorCounter = 0;

    m_serialPort = new SerialPort();


    // connect signals
    connect(m_serialPort, SIGNAL(readyRead()),this,SLOT(readData()));

}

TrackingSensor::~TrackingSensor(){
    delete m_serialPort;
}

void TrackingSensor::calibrate(){

}


// serialport methods
void TrackingSensor::setupConnection()
{
    qDebug() << "Trying to set up connection";
    qDebug() << "Available Ports: " << SerialPortInfo::availablePorts().size();

    // check if connection is availabel
    foreach (const SerialPortInfo &info, SerialPortInfo::availablePorts()) {
        this->setComportAvailable(true);
        qDebug() << "Name        : " << info.portName();
        qDebug() << "Description : " << info.description();
        qDebug() << "Manufacturer: " << info.manufacturer();

        m_serialPort->setPort(info);

    }
}
void TrackingSensor::openConnection()
{
    if(this->comportAvailable()){
        if(m_serialPort->open(QIODevice::ReadWrite)){
            this->setConnectionStatus(true);
            qDebug() << "Serialport open";
            m_serialPort->setRate(baudrate);
            m_serialPort->setDataBits(static_cast<SerialPort::DataBits>(8));
            m_serialPort->setParity(static_cast<SerialPort::Parity>(0));
            m_serialPort->setStopBits(static_cast<SerialPort::StopBits>(1));
            m_serialPort->setFlowControl(static_cast<SerialPort::FlowControl>(0));
        }else
        {
             this->setConnectionStatus(false);
            qDebug() << "Serialport couldn't be opened";
            closeConnection();
        }
    }
    else
        qDebug() << "Can't open -> no comport available!";
}

void TrackingSensor::closeConnection()
{
   // if(m_serialPort->isOpen()){
        m_serialPort->close();
        this->setConnectionStatus(false);
    //}
}

void TrackingSensor::readData()
{
    qint64 maxLength = 1024;
   // QByteArray data = m_serialPort->readAll();      // reads till \0
    QByteArray data = m_serialPort->read(m_serialPort->bytesAvailable());

    qDebug() << "x: "<< m_sensorCounter << "data: " << data;

    QString* value = new QString(data);
    if(value->contains("##")){
        m_sensorCounter=2;
        value->replace(3,2,"");
        qDebug() << "new cycle ("<<*value<<")";
        data = value->toUtf8();
    }

    double scale = 1000.0;
    int minLeft = 289, minRight=253, minBottom=321;
    int maxLeft = 330, maxRight=270, maxBottom=370;

    int calcVal = data.toInt();

    switch(this->m_sensorCounter){
        case 0:     // x    left
            m_sensorCounter++;
            //this->setLeftSensor(int(sqrt(scale/data.toDouble())));
            if(calcVal > maxLeft)
                calcVal=maxLeft;

            calcVal -= minLeft;
            if(calcVal<=0)
                calcVal = 1;
            this->setLeftSensor(int(sqrt(scale/(double)calcVal)));
            qDebug() << "Left: " << calcVal;
            break;
        case 1:     // y    bottm
            m_sensorCounter++;
            //this->setBottomSensor(int(sqrt(scale/data.toDouble())));
            if(calcVal > maxBottom)
                calcVal=maxBottom;
            calcVal -= minBottom;
            if(calcVal<=0)
                calcVal = 1;
            this->setBottomSensor(int(sqrt(scale/(double)calcVal)));
            qDebug() << "Bottom: " << calcVal;
            break;
        case 2:     // z    right
            m_sensorCounter=0;
            //this->setRightSensor(int(sqrt(scale/data.toDouble())));
            if(calcVal > maxRight)
                calcVal=maxRight;
            calcVal -= minRight;
            if(calcVal<=0)
                calcVal = 1;
            this->setRightSensor(int(sqrt(scale/(double)calcVal)));
            qDebug() << "Right: " << calcVal;
            break;
        default:
            m_sensorCounter=0;
            break;
    }
    qDebug() <<"\n";

}

// getter/ setter
const QString TrackingSensor::sensorValue() const{
    return m_sensorValue;
}
const bool TrackingSensor::connectionAvailable() const{
    return m_connectionAvailable;
}
const bool TrackingSensor::comportAvailable() const{
    return this->m_comPortAvailable;
}

void TrackingSensor::setSensorValue(const QString &newValue){
    if (m_sensorValue != newValue) {
        m_sensorValue = newValue;
        //update();
        emit sensorChanged();
    }
}
void TrackingSensor::setComportAvailable(const bool &newValue){
    if (m_comPortAvailable != newValue) {
        m_comPortAvailable = newValue;
        //update();
        emit comportAvailableChanged();
    }
}
void TrackingSensor::setConnectionStatus(const bool &newValue){
    if (m_connectionAvailable != newValue) {
        m_connectionAvailable = newValue;
        //update();
        emit connectionAvailableChanged();
    }
}



void TrackingSensor::setLeftSensor(const int &newValue){
    if (m_left != newValue) {
        m_left = newValue;
        emit leftSensorChanged();
    }
}
void TrackingSensor::setRightSensor(const int &newValue){
    if (m_right != newValue) {
        m_right = newValue;
        emit rightSensorChanged();
    }
}
void TrackingSensor::setBottomSensor(const int &newValue){
    if (m_bottom != newValue) {
        m_bottom = newValue;
        emit bottomSensorChanged();
    }
}



const int TrackingSensor::bottomSensor()const{
    return m_bottom;
}
const int  TrackingSensor::leftSensor()const{
    return m_left;
}
const int TrackingSensor::rightSensor()const{
    return m_right;
}









