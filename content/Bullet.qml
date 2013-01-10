import QtQuick 2.0
import Shapes 3.0

Ellipse {
    width: 10
    height: 10



    Behavior on x {
        enabled: true;
        SpringAnimation{ spring: 2; damping: 0.2 }
    }
    Behavior on y {
        SpringAnimation{ spring: 2; damping: 0.2 }
    }
}
