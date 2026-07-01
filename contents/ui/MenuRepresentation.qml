/*****************************************************************************
 *   Copyright (C) 2014 by Weng Xuetian <wengxt@gmail.com>                   *
 *   Copyright (C) 2013-2017 by Eike Hein <hein@kde.org>                     *
 *   Copyright (C) 2021 by Prateek SU <pankajsunal123@gmail.com>             *
 *   Copyright (C) 2022 by Friedrich Schriewer <friedrich.schriewer@gmx.net> *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts
import QtQml
import QtQuick.Window
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmaCore.Dialog {
	id: root

	objectName: "popupWindow"
	flags: Qt.WindowStaysOnTopHint

	backgroundHints: PlasmaCore.Types.NoBackground

	location: "Floating"
	hideOnWindowDeactivate: true

	Plasmoid.status: root.visible ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

	property int iconSize: { 
		switch(Plasmoid.configuration.appsIconSize){
			case 0: return Kirigami.Units.iconSizes.smallMedium;
			case 1: return Kirigami.Units.iconSizes.medium;
			case 2: return Kirigami.Units.iconSizes.large;
			case 3: return Kirigami.Units.iconSizes.huge;
			default: return 64
		}
	}

	property int columns: Plasmoid.configuration.numberColumns

	property int cellSizeHeight: iconSize
								+ Kirigami.Units.gridUnit * 2
								+ (2 * Math.max(
												highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
												highlightItemSvg.margins.left + highlightItemSvg.margins.right
												)
								  )
	property int cellSizeWidth: cellSizeHeight //+ Kirigami.Units.gridUnit
	property int rows: plasmoid.configuration.numberOfRows
	
	onVisibleChanged: {
		if (!visible) {
			reset();
		} else {
			var pos = popupPosition(width, height);
			x = pos.x;
			y = pos.y;
			requestActivate();
		}
	}

	onHeightChanged: {
		var pos = popupPosition(width, height);
		x = pos.x;
		y = pos.y;
	}

	onWidthChanged: {
		var pos = popupPosition(width, height);
		x = pos.x;
		y = pos.y;
	}

	function toggle() {
		root.visible = false;
	}

	function reset() {
		main.reset()
	}

	function popupPosition(width, height) {
		var x = (Screen.width - width) / 2;
		var y = (Screen.height - height) / 2;
		return Qt.point(x, y);
	}

	FocusScope {
		id: fs
		focus: true
		width:  (root.cellSizeWidth * Plasmoid.configuration.numberColumns)+ innerPadding*2
		height: 40 + 2 + 40 + (root.cellSizeHeight * rows) + innerPadding * 2
		
		property real innerPadding: 16

		Rectangle {
			anchors.fill: parent
			radius: main.glassRadius
			color: main.glassFill
			border.width: 1
			border.color: main.glassBorderColor
		}

		MainView {
			id: main
			anchors.fill: parent
			anchors.margins: fs.innerPadding
		}

		Keys.onPressed: {
			if (event.key == Qt.Key_Escape) {
				root.visible = false;
			}
		}
	}

	function refreshModel() {
		main.reload()
	}

	Component.onCompleted: {
		kicker.reset.connect(reset);
		rootModel.refresh();
	}
}
