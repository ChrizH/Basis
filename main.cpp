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
#include "ellipseitem.h"
#include "trackingSensor.h"
#include <QDebug>
#
#include <QtQml>

void initialize();
void mainLoop();

int main(int argc, char *argv[])
{
    TrackingSensor* trackSensor = new TrackingSensor();
    //trackSensor->setupConnection();
    //trackSensor->openConnection();
    QGuiApplication app(argc, argv);
    qmlRegisterType<EllipseItem>("Shapes", 3, 0, "Ellipse");

    QQuickView *view = new QQuickView;
    QQmlContext *context = view->engine()->rootContext();
    context->setContextProperty("_trackingSensor",trackSensor);
    view->setSource(QUrl("qrc:///tracking.qml"));
    view->show();
    return app.exec();
}

void mainLoop(){
    while(1) {
        sleep(1/30);
    }
}
