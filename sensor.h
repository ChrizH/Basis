#ifndef COORDLIMITS_H
#define COORDLIMITS_H
#include <QtCore/QtGlobal>
#include <QObject>
class Sensor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int value READ value NOTIFY valueChanged)
    Q_PROPERTY(int minValue READ minValue WRITE setMinValue NOTIFY minValueChanged)
    Q_PROPERTY(int maxValue READ maxValue WRITE setMaxValue NOTIFY maxValueChanged)
    //Q_PROPERTY(int stopValue READ stopValue WRITE setStopValue)
public:
    Sensor(QObject *parent=0);
    int maxValue();
    int minValue();
    int value();
    void setValue(int);

signals:
    void valueChanged();
    void minValueChanged();
    void maxValueChanged();

public slots:
    void setMinValue(const int&);
    void setMaxValue(const int&);
    void calibrate(int);
    void assignCalibration();
private:
    int m_min;
    int m_max;
    int m_value;

    int m_calMinHelper;
    int m_calMaxHelper;

    bool m_calibrating;

};

#endif // COORDLIMITS_H
