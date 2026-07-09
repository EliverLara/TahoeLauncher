/*****************************************************************************
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
import Qt5Compat.GraphicalEffects
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.coreaddons as KCoreAddons

import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

import "js/colorType.js" as ColorType

Item {
	id: main
	property bool searching: (searchBar.textField.text != "")

	readonly property color textColor: Kirigami.Theme.textColor
	readonly property string textFont: Kirigami.Theme.defaultFont//plasmoid.configuration.useSystemFontSettings ? Kirigami.Theme.defaultFont : "SF Pro Text"
	readonly property real textSize: 10//plasmoid.configuration.useSystemFontSettings ? Kirigami.Theme.defaultFont.pointSize : 11
	readonly property color bgColor: Kirigami.Theme.backgroundColor
	readonly property color highlightColor: Kirigami.Theme.highlightColor
	readonly property color highlightedTextColor: Kirigami.Theme.highlightedTextColor
	readonly property bool isTop: plasmoid.location == PlasmaCore.Types.TopEdge & plasmoid.configuration.launcherPosition != 2 & !plasmoid.configuration.floating

	property bool isDarkTheme: ColorType.isDark(bgColor)
	property color contrastBgColor: isDarkTheme ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(0, 0, 0, 0.1)
	property color dimmedTextColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.7)

	// Liquid Glass properties
	property color glassFill: Qt.rgba(0.08, 0.08, 0.14, 0.65)
	property color glassFillHover: Qt.rgba(0.12, 0.12, 0.20, 0.72)
	property color glassBorderColor: isDarkTheme ? Qt.rgba(1.0, 1.0, 1.0, 0.13) : Qt.rgba(1.0, 1.0, 1.0, 0.13)
	property color glassBorderHighlight: isDarkTheme ? Qt.rgba(255, 255, 255, 0.5) : Qt.rgba(255, 255, 255, 0.7)
	property color glassShadowColor: isDarkTheme ? Qt.rgba(0, 0, 0, 0.3) : Qt.rgba(0, 0, 0, 0.15)
	property int glassRadius: 32
	property int glassRadiusIcon: 16
	property int glassRadiusSmall: 16

	property bool showAllApps: true

	function reload() {
		searchBar.textField.clear()
		appList.reset()
	}
	function reset(){
		searchBar.textField.clear()
		appList.reset()
	}

	ColumnLayout {

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		spacing: 0

		SearchBar {
			id: searchBar
			Layout.fillWidth: true
			Layout.preferredHeight: 40
			Layout.maximumHeight: Layout.preferredHeight
			showMenuButton: !searching
			Keys.priority: Keys.AfterItem
			Keys.forwardTo: searching ? searchList : appList.viewItem
		}

		AllAppsList{
			id: appList
			state: "visible"
			Layout.fillHeight: true
			Layout.fillWidth: true

			Keys.priority: Keys.AfterItem
			Keys.forwardTo: searchBar.textField

			visible: opacity > 0
			states: [
				State {
					name: "visible"; when: (!searching)
					PropertyChanges { target: appList; opacity: 1.0 }
				},
				State {
					name: "hidden"; when: (searching)
					PropertyChanges { target: appList; opacity: 0.0}
				}
			]
			transitions: [
				Transition {
					to: "visible"
					PropertyAnimation {properties: 'opacity'; duration: 100; easing.type: Easing.OutQuart}
				},
				Transition {
					to: "hidden"
					PropertyAnimation {properties: 'opacity'; duration: 100; easing.type: Easing.OutQuart}
				}
			]
		}

		SearchList {
			id: searchList
			state: "hidden"
			visible: opacity > 0

			Layout.fillWidth: true
			Layout.fillHeight: true

			states: [
				State {
					name: "visible"; when: (searching)
					PropertyChanges { target: searchList; opacity: 1.0 }
				},
				State {
					name: "hidden"; when: (!searching)
					PropertyChanges { target: searchList; opacity: 0.0}
				}
			]
			transitions: [
				Transition {
					to: "visible"
					PropertyAnimation {properties: 'opacity'; duration: 100; easing.type: Easing.OutQuart}
				},
				Transition {
					to: "hidden"
					PropertyAnimation {properties: 'opacity'; duration: 100; easing.type: Easing.OutQuart}
				}
			]

			Keys.priority: Keys.AfterItem
			Keys.forwardTo: searchBar.textField
		}
	}
}
