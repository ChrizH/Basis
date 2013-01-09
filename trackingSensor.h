#ifndef SENSORS_H
#define SENSORS_H
#include "sensor.h"
#include <QtAddOnSerialPort/serialport.h>
#include <QtAddOnSerialPort/serialportinfo.h>
#include <QQuickPaintedItem>
#include <QDebug>
#include <QtCore/QtGlobal>

//QT_BEGIN_NAMESPACE_SERIALPORT
//class SerialPort;
//QT_END_NAMESPACE_SERIALPORT

QT_USE_NAMESPACE_SERIALPORT

class TrackingSensor : public QObject
{
    // properties must be at top
    Q_OBJECT
    Q_PROPERTY(QString sensorInput READ sensorValue WRITE setSensorValue NOTIFY sensorChanged)      // the string with all 3
    Q_PROPERTY(bool comportAvailable READ comportAvailable WRITE setComportAvailable NOTIFY comportAvailableChanged)
    Q_PROPERTY(bool connectionAvailable READ connectionAvailable WRITE setConnectionStatus NOTIFY connectionAvailableChanged)
    Q_PROPERTY(int leftSensor READ leftSensor WRITE setLeftSensor NOTIFY leftSensorChanged)
    Q_PROPERTY(int rightSensor READ rightSensor WRITE setRightSensor NOTIFY rightSensorChanged)
    Q_PROPERTY(int bottomSensor READ bottomSensor WRITE setBottomSensor NOTIFY bottomSensorChanged)
public:
    TrackingSensor(QObject *parent=0);
    ~TrackingSensor();
    // void paint(QPainter *painter);

    /**
     * @brief calibrate
     * Test sensor area - go with the hand through the half cube
     * The method checks and assigns the max/min values for each sensor
     */
    void calibrate();

    void setLeftSensor(const int &newValue);
    void setRightSensor(const int &newValue);
    void setBottomSensor(const int &newValue);
    const int leftSensor() const;
    const int rightSensor() const;
    const int bottomSensor() const;

    const QString sensorValue() const;
    const bool connectionAvailable() const;
    const bool comportAvailable() const;
    void setSensorValue(const QString &newValue);

    void setComportAvailable(const bool &newValue);
    void setConnectionStatus(const bool &newValue);

    // methods for serialcommunication
public slots:
    void setupConnection();         // TODO: send a start command to µC
    void closeConnection();
    void openConnection();
    void readData();

signals:
    void sensorChanged();
    void leftSensorChanged();
    void rightSensorChanged();
    void bottomSensorChanged();

    // communication changed
    void connectionAvailableChanged();
    void comportAvailableChanged();

private:
    // sensor values
    int m_left;     // x-coord
    int m_bottom;   // y
    int m_right;    // z
    QString m_sensorValue;


    bool m_comPortAvailable;
    bool m_connectionAvailable;
    int m_sensorCounter;    // readData -> 1 read cycle: 3
    SerialPort* m_serialPort;
};

#endif // TrackingSensor_H
