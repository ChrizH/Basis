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

    m_serialPort = new SerialPort(this);
    m_sensorX = new Sensor();
    m_sensorY = new Sensor();
    m_sensorZ = new Sensor();
    // setdefault sensor borderValues
    /*m_sensorX->setMinValue(297);
    m_sensorX->setMaxValue(m_sensorX->minValue()+30);
    m_sensorY->setMinValue(332);
    m_sensorY->setMaxValue(m_sensorY->minValue()+30);
    m_sensorZ->setMinValue(272);
    m_sensorZ->setMaxValue(m_sensorZ->minValue()+30);*/
    m_calibrating = false;

    m_serialHelper = 0;
    // connect signals
    connect(m_serialPort, SIGNAL(readyRead()),this,SLOT(readData()));

}

TrackingSensor::~TrackingSensor(){
    delete m_serialPort;
    delete m_sensorX;
    delete m_sensorY;
    delete m_sensorZ;
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


            //m_serialPort->clear();
            //m_serialPort->reset();
            if(m_serialPort->setRate(baudrate)
                &&m_serialPort->setDataBits(static_cast<SerialPort::DataBits>(8))
                &&m_serialPort->setParity(static_cast<SerialPort::Parity>(0))
                &&m_serialPort->setStopBits(static_cast<SerialPort::StopBits>(1))
                &&m_serialPort->setFlowControl(static_cast<SerialPort::FlowControl>(0))){
                qDebug() << "Serialport open";
            }else
                qDebug() << "Can't configure serialport";
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
    char* s;
    //QByteArray d = m_serialPort->readAll();
    QByteArray data = m_serialPort->read(m_serialPort->bytesAvailable());


    //QString test = QString(d);
    // qDebug() << "Input: " << test;

    /*if(test=="#"&&m_serialHelper==0)
        m_serialHelper++;
    else if(test=="#"&&m_serialHelper==1){
        m_serialHelper=0;
        m_sensorCounter=0;
        qDebug() << "new cycle";
    }*/

    QString* value = new QString(data);
    qDebug() << "Input: "<<*value;

    // check correct reading
    if(value->length()==1){
        m_sensorCounter++;
        return;
    }
    if(!(value->length()==3||value->length()==5)){
        qDebug() << "Reading error";
        return;
    }

    if(value->contains("##"))
        if(value->length()==5){
            m_sensorCounter=1;
            value->replace(3,2,"");
            //qDebug() << "new cycle ("<<*value<<")";
            data = value->toUtf8();
        }
        else{
            qDebug() << "Reading error";
            m_sensorCounter++;
            return;
        }

    int calcVal = data.toInt();


    switch(this->m_sensorCounter){
        case 0:     // x    left
            m_sensorCounter++;
            if(!m_calibrating)
                m_sensorX->setValue(calcVal);
            else
                m_sensorX->calibrate(calcVal);

            qDebug() << "X: " << calcVal;
            break;
        case 1:     // y    bottom
            m_sensorCounter=0;
            if(!m_calibrating)
                m_sensorY->setValue(calcVal);
            else
                m_sensorY->calibrate(calcVal);

            qDebug() << "\t\tY: " << calcVal;
            break;
        /*case 2:     // z    right
            m_sensorCounter=0;
            if(!m_calibrating)
                m_sensorZ->setValue(calcVal);
            else
                m_sensorZ->calibrate(calcVal);

            qDebug() << "Z: " << calcVal;
            break;*/
        default:
            m_sensorCounter=0;
            break;
    }
    qDebug() <<"\n---------------";

}

void TrackingSensor::showCalResults(){
    qDebug()<<"\nCalibrating results:";
    qDebug()<<"(X-Axis): min="<<m_sensorX->minValue()<<" max="<<m_sensorX->maxValue();
    qDebug()<<"(Y-Axis): min="<<m_sensorY->minValue()<<" max="<<m_sensorY->maxValue();
    qDebug()<<"(Z-Axis): min="<<m_sensorZ->minValue()<<" max="<<m_sensorZ->maxValue();
}

bool TrackingSensor::calibrating(){
    return m_calibrating;
}
void TrackingSensor::setCalibrating(bool calibrate){
    if(m_calibrating==calibrate)
        return;
    m_calibrating=calibrate;
    emit calibratingChanged();
}

Sensor* TrackingSensor::sensorX(){
    return m_sensorX;
}
Sensor* TrackingSensor::sensorY(){
    return m_sensorY;
}
Sensor* TrackingSensor::sensorZ(){
    return m_sensorZ;
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









