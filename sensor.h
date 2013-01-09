#ifndef COORDLIMITS_H
#define COORDLIMITS_H

class Sensor
{
    int m_min;
    int m_max;
    int m_value;
public:
    Sensor();
    int getMax();
    int getMin();
    void setMin(int);
    void setMax(int);
};

#endif // COORDLIMITS_H
