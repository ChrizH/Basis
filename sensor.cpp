#include "sensor.h"

/**
 * @brief CoordLimits::CoordLimits
 * Max/Min Value for one coordinate of the sensor
*/
Sensor::Sensor()
{
    // fill with standard values
}

int Sensor::getMax(){
    return m_max;
}
int Sensor::getMin(){
    return m_min;
}
void Sensor::setMax(int max){
    m_max=max;
}
void Sensor::setMin(int min){
    m_min=min;
}

