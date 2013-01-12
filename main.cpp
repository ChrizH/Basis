/*************************************************************************
 *
 * Copyright (c) 2012 Digia Plc.
 * All rights reserved.
 *
 * See the LICENSE.txt file shipped along with this file for the license.
 *
 *************************************************************************/

#include <QGuiApplication>
#include <QQuickView>
#include "moveable.h"
#include "trackingSensor.h"
#include <QDebug>
#include "game.h"
#include <QtQml>
#include "timer.h"

int main(int argc, char *argv[])
{
    Game* game = new Game();

    QGuiApplication app(argc, argv);
    qmlRegisterType<MoveAble>("Shapes", 3, 0, "Ellipse");

    qmlRegisterType<TrackingSensor>("TrackingSensor",1,0,"TrackingSensor");
    qmlRegisterType<Timer>( "CustomComponents", 1, 0, "Timer" );
    QQuickView *view = new QQuickView;
    QQmlContext *context = view->engine()->rootContext();
    context->setContextProperty("_gameEngine",game);
    view->setSource(QUrl("qrc:///tracking.qml"));
    view->show();

    return app.exec();
}

