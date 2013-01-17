#ifndef SENSORS_H
#define SENSORS_H
#include "sensor.h"
#include <QtAddOnSerialPort/serialport.h>
#include <QtAddOnSerialPort/serialportinfo.h>
#include <QQuickPaintedItem>
#include <QDebug>
#include <QtCore/QtGlobal>
#include "sensor.h"

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

    Q_PROPERTY(Sensor* sensorX READ sensorX NOTIFY sensorXChanged)
    Q_PROPERTY(Sensor* sensorY READ sensorY NOTIFY sensorYChanged)
    Q_PROPERTY(Sensor* sensorZ READ sensorZ NOTIFY sensorZChanged)
    Q_PROPERTY(bool calibrating READ calibrating WRITE setCalibrating NOTIFY calibratingChanged)


    Q_PROPERTY(int leftSensor READ leftSensor WRITE setLeftSensor NOTIFY leftSensorChanged)
    Q_PROPERTY(int rightSensor READ rightSensor WRITE setRightSensor NOTIFY rightSensorChanged)
    Q_PROPERTY(int bottomSensor READ bottomSensor WRITE setBottomSensor NOTIFY bottomSensorChanged)

    /*Q_PROPERTY(int minLeft READ minLeft WRITE setMinLeft NOTIFY minLeftChanged)
    Q_PROPERTY(int minRight READ minRight WRITE setMinRight NOTIFY minRightChanged)
    Q_PROPERTY(int minBottom READ minBottom WRITE setMinBottom NOTIFY minBottomChanged)
    Q_PROPERTY(int maxDelta READ maxDelta WRITE setMaxDelta NOTIFY maxDeltaChanged)*/
public:
    TrackingSensor(QObject *parent=0);
    ~TrackingSensor();
    // void paint(QPainter *painter);

    /**
     * @brief calibrate
     * Test sensor area - go with the hand through the half cube
     * The method checks and assigns the max/min values for each sensor
     */
    //void calibrate();

    void setLeftSensor(const int &newValue);
    void setRightSensor(const int &newValue);
    void setBottomSensor(const int &newValue);
    const int leftSensor() const;
    const int rightSensor() const;
    const int bottomSensor() const;

    Sensor* sensorX();
    Sensor* sensorY();
    Sensor* sensorZ();


    const QString sensorValue() const;
    const bool connectionAvailable() const;
    const bool comportAvailable() const;
    bool calibrating();

    void setSensorValue(const QString &newValue);


    void setComportAvailable(const bool &newValue);
    void setConnectionStatus(const bool &newValue);
public slots:
    // methods for serialcommunication

    void setupConnection();         // TODO: send a start command to µC
    void closeConnection();
    void openConnection();
    void readData();
    void setCalibrating(bool);
    void showCalResults();

signals:
    void sensorChanged();
    void leftSensorChanged();
    void rightSensorChanged();
    void bottomSensorChanged();
    void calibratingChanged();

    void sensorXChanged();
    void sensorYChanged();
    void sensorZChanged();


    // communication changed
    void connectionAvailableChanged();
    void comportAvailableChanged();

private:
    // sensor values
    int m_left;     // x-coord
    int m_bottom;   // y
    int m_right;    // z
    QString m_sensorValue;

    Sensor* m_sensorX;
    Sensor* m_sensorY;
    Sensor* m_sensorZ;

    bool m_comPortAvailable;
    bool m_connectionAvailable;
    bool m_calibrating;
    int m_sensorCounter;    // readData -> 1 read cycle: 3
    SerialPort* m_serialPort;
    int m_serialHelper;
};




#endif // TrackingSensor_H
