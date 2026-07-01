import QtQuick 
import org.kde.kirigami as Kirigami

Text {
    id: pill

    property bool selected: false
    signal clicked

    topPadding: 4
    bottomPadding: topPadding
    leftPadding: 10
    rightPadding: 10
    font.pointSize: 10

    color: selected ? Qt.rgba(1, 1, 1, 0.95) : main.dimmedTextColor
    opacity: selected ? 1.0 : 0.65

    MouseArea {
        anchors.fill: pill
        onClicked: pill.clicked();
    }
}
