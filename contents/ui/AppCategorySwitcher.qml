import QtQuick
import QtQuick.Controls

ScrollView {
    id: scrollview

    property alias model: categorySwitcher.model

    signal categorySwitched(int index)

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    padding: 0

    background: Item {}

    AppListView {
        id: categorySwitcher
        spacing: 7
        orientation: ListView.Horizontal
        showScrollbar: false
        showHighlight: false
        property var contentHeight: 0

        anchors.topMargin: Math.max(0, (parent.height - contentHeight) / 2)
        anchors.fill: parent
        
        delegate: CategoryPill {
            id: del
            required property var model
            required property var index
            selected: categorySwitcher.currentIndex == index
            text: model.name

            onClicked: categorySwitcher.currentIndex = index

            Component.onCompleted: {
                categorySwitcher.contentHeight = del.height
            }
        }

        onCurrentIndexChanged: {
            if (categorySwitcher.currentItem && categorySwitcher.currentItem.model) {
                categorySwitched(categorySwitcher.currentItem.model.modelIndex)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        // Accept mouse wheel events, but pass other events through to the ScrollView
        acceptedButtons: Qt.NoButton
        hoverEnabled: true

        onWheel: (wheel) => {
            // Check if the scroll wheel is moving vertically
            if (wheel.angleDelta.y !== 0) {

                categorySwitcher.flick(wheel.angleDelta.y * 15, 0);

                wheel.accepted = true;
            }
        }
    }
}
