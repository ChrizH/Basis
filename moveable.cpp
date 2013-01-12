/*************************************************************************
 *
 * Copyright (c) 2012 Digia Plc.
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#include <QtGui>
#include "moveable.h"

MoveAble::MoveAble(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    //QTimer::singleShot(2000, this, SIGNAL(ready()));
}

void MoveAble::paint(QPainter *painter)
{
    painter->save();
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_color);
    painter->drawEllipse(boundingRect());
    painter->restore();
}

const QColor MoveAble::color() const
{
    return m_color;
}

void MoveAble::setColor(const QColor &newColor)
{
    if (m_color != newColor) {
        m_color = newColor;
        update();
        emit colorChanged();
    }
}

void MoveAble::move(const qreal &dx, const qreal &dy){
    // check border
    //&x+=&dx;
    //setPosition(new QPointF(this->x()+dx,this->y()+dy));
    this->xChanged();
    this->yChanged();
    this->update();
}


