/*************************************************************************
 *
 * Copyright (c) 2012 Digia Plc.
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#ifndef ELLIPSEITEM_H
#define ELLIPSEITEM_H

#include <QQuickPaintedItem>


struct Settings{
    static const int GAME_HEIGHT = 500;
    static const int GAME_WIDTH = 1000;
    static const int ENEMIES = 10;
};



class MoveAble : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
public:
    MoveAble(QQuickItem *parent = 0);
    MoveAble(qreal x, qreal y);
    void paint(QPainter *painter);

    const QColor color() const;
    void setColor(const QColor &newColor);
    void move(const qreal &dx, const qreal &dy);
signals:
    void colorChanged();
    void ready();

private:
    QColor m_color;

};

#endif
