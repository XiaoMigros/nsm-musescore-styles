import MuseScore 3.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.0

MuseScore {
	menuPath: "Plugins.NSM Copyright Generator"
	version: "1.0"
    description: qsTr("Generates copyright text in the https://NinSheetMusic.org/ format.")
	requiresScore: true
	id: nsmCopyright
	
	Component.onCompleted: {
		if (mscoreMajorVersion >= 4) {
			nsmCopyright.title			= qsTr("NSM Copyright Generator");
			nsmCopyright.categoryCode	= "file-management";
		}//if
	}//component
	
	onRun: {dialog.open()}
	
	Dialog {
		id: dialog
		title: "NSM Copyright Generator"
		GridLayout {
			rowSpacing:		10
			columnSpacing:	10
			anchors.margins:10
			columns:		2
			
			Label {text: "Line 1"}
			
			TextField {id: line1; implicitWidth: 240; placeholderText: "Company © YEAR"; text: "Company © YEAR"}
			
			Label {text: "Line 2"}
			
			TextField {id: line2; implicitWidth: 240; placeholderText: "https://www.NinSheetMusic.org/"; text: "https://www.NinSheetMusic.org/"}
		}//GridLayout
		onAccepted: {curScore.setMetaTag("copyright", (line1.text + "\n" + line2.text))}
	}//Dialog
	
	Settings {
		id: settings
		category: "NSM Copyright Plugin"
		property alias line1: line1.text
		property alias line2: line2.text
	}//Settings
}//MuseScore