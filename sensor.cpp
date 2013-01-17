#include "sensor.h"

/**
 * @brief CoordLimits::CoordLimits
 * Max/Min Value for one coordinate of the sensor
*/
Sensor::Sensor(QObject *parent)
    :QObject(parent)
{
    // fill with standard values
    m_calMinHelper = 100000;
    m_calMaxHelper = 0;
}



int Sensor::value(){
    return m_value;
}
void Sensor::assignCalibration(){
    m_min = m_calMinHelper+3;
    m_max = m_calMaxHelper;

    m_calMinHelper = 100000;
    m_calMaxHelper = 0;
}

void Sensor::calibrate(int val){
    // find min&max
    //if(val>200){    // error check
        if(m_calMinHelper > val)
            m_calMinHelper = val;
        if(m_calMaxHelper < val)
            m_calMaxHelper = val;
    //}
}

void Sensor::setValue(int val){

    //if(!m_calibrating)
    // check if val is during borders
    if(val>=m_min&&val<=m_max){

        if(m_value == val)
            return;

        m_value = val - m_min +1;

    }else
        m_value = -100;     // stopval

    emit valueChanged();

}

int Sensor::maxValue(){
    return m_max;
}
int Sensor::minValue(){
    return m_min;
}
void Sensor::setMaxValue(const int &max){
    if(m_max=max)
        return;
    m_max=max;
    emit maxValueChanged();
}
void Sensor::setMinValue(const int &min){
    if(m_min=min)
        return;
    m_min=min;
    emit minValueChanged();
}

