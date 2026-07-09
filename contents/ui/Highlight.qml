import QtQuick
import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

Rectangle {
    id: highlight
    property bool hovered: ListView.view !== null || GridView.view !== null
    property bool pressed: false
    property alias marginHints: background.margins
    property bool active: true
    property bool hideBg: true

    width: {
        const view = ListView.view;
        return view ? view.width - view.leftMargin - view.rightMargin : undefined;
    } 

    radius: main.glassRadiusSmall
    z: -20
    color: main.glassFillHover
    clip: true

    KSvg.FrameSvgItem {
        id: background
        anchors.fill: parent
        opacity: highlight.hideBg ? 0 : 1
        imagePath: "widgets/viewitem"
        prefix: {
            if (highlight.pressed) {
                return highlight.hovered ? 'selected+hover' : 'selected';
            }
            return highlight.hovered ? 'hover' : 'normal';
        }
        Behavior on opacity {
            enabled: Kirigami.Units.veryShortDuration > 0
            NumberAnimation {
                duration: Kirigami.Units.veryShortDuration
                easing.type: Easing.OutQuad
            }
        }
    }
}
