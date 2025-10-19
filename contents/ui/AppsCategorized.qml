import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

AppListView {
	id: appsCategorized

	showSectionSeparator: false
	highlightFollowsCurrentItem: false
	spacing: 15

	delegate: GridView {
		id: grid
		
		property var currentCategory: slicedCategories[index]
		property bool expanded: false
		property bool canMoveWithKeyboard: false
		property var rows: {
            if(grid.model.count%root.columns == 0 )  {
                return Math.floor(grid.model.count/root.columns);
            }
            return Math.floor((grid.model.count/root.columns)+1);
        }

		property var expandedHeight: rows * root.cellSizeHeight
		property var headerHeight: null

        focus: expanded
		clip: true
		interactive: false

        width: appsCategorized.availableWidth
		height: root.cellSizeHeight
		cellWidth: root.cellSizeWidth
		cellHeight: root.cellSizeHeight
		model: rootModel.modelForRow(currentCategory.modelIndex);

		header: ColumnLayout {
			width: grid.width
			spacing: 15
			Rectangle {
                id: separator
				width: parent.width
				height: 1.5
                // not showing on the first item to avoid duplicating with searchbar separator
				color: index > 0 ? main.contrastBgColor : "transparent"
			}
			RowLayout {
				Layout.fillWidth: true

				Text {
					text:currentCategory.name
					font.bold: true
					font.pixelSize: 15
					color: main.textColor
				}

				Item {
					Layout.fillWidth: true
					Layout.fillHeight: true
				}

				Text {
					Layout.alignment: Qt.AlignHCenter | Qt.AlignRight
					text: grid.expanded ? "Show less" : "Show more"
					visible: grid.rows > 1
					font.bold: true
					font.pixelSize: 15
					color: main.textColor
					MouseArea {
						anchors.fill: parent
						onClicked: {
						    expanded = !expanded
						}
					}
				}
			}
			Item {
					Layout.fillWidth: true
					Layout.fillHeight: true
				}
		}
		
		delegate: AppGridViewDelegate {
            id: favitem
            triggerModel: grid.model
		}

        onExpandedHeightChanged: updateHeight()
		
		onExpandedChanged: updateHeight()

		Behavior on height {
			NumberAnimation { duration: 200 }
		}

		function updateHeight () {
            if(expanded) {
                grid.height = grid.expandedHeight + grid.headerHeight;
            }else {
                grid.height = root.cellSizeHeight + grid.headerHeight;
            }
		}

		Component.onCompleted: {
            grid.headerHeight = grid.headerItem.height;
            updateHeight()
		}

	}
}