import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

import MuseScore 3.0
import "lists"

MuseScore {
	menuPath: "Plugins." + qsTr("NSM Tools") + "." + qsTr("Add Tempo Marking")
	description: qsTr("Adds a Tempo/BPM Marking in the https://NinSheetMusic.org/ standard.")
	version: "1.0"
	property var cursor
	property int spacing: 10
	property int pContentWidth: 240
	property int boxHeight: 30
	property int boxWidth: 60
	
	onRun: {
		cursor = curScore.newCursor()
		cursor.inputStateMode = Cursor.INPUT_STATE_SYNC_WITH_SCORE
		dialog.open()
	}
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = qsTr("NSM BPM Generator")
        }
    }//Component
	
	Dialog {
		id: dialog
		standardButtons: StandardButton.Cancel | StandardButton.Ok
		
		ColumnLayout {
			spacing: spacing
			anchors.horizontalCenter: parent.horizontalCenter
			
			RowLayout {
				spacing: spacing
				width: pContentWidth
				anchors.horizontalCenter: parent.horizontalCenter
				
				Label {id: eLabel; text: qsTr("Expression:")}
				
				TextField {
					id: expressionField
					placeholderText: qsTranslate("Ms::MuseScore", "Expression")
					implicitWidth: pContentWidth - eLabel.width - 3 * parent.spacing
				}
			}//RowLayout
			
			Button {
				id: modulBox
				checkable: true
				checked: false
				text: (checked ? qsTr("No") : qsTr("Add")) + " " + qsTr("Metric Modulation")
				anchors.horizontalCenter: parent.horizontalCenter
			}
			
			Rectangle {
				width: pContentWidth
				visible: modulBox.checked
				color: "transparent"
				border.width: 1
				border.color: "#888888"
				height: children[0].height + 2 * spacing
				anchors.horizontalCenter: parent.horizontalCenter
				
				ColumnLayout {
					spacing: spacing
					anchors.centerIn: parent
					
					RowLayout {
						spacing: spacing
						NoteBox {id: modul1}
						
						Label {text: "="}
						
						NoteBox {id: modul2}
					}
				
					CheckBox {
						id: modulParentheses
						checked: true
						text: qsTr("Add Parentheses")
					}
				}//ColumnLayout
			}//Rectangle
			
			Button {
				id: bpmBox
				checkable: true
				checked: false
				text: (checked ? qsTr("No") : qsTr("Add")) + " " + qsTr("BPM Marking")
				anchors.horizontalCenter: parent.horizontalCenter
			}
			
			Rectangle {
				width: pContentWidth
				visible: bpmBox.checked
				color: "transparent"
				border.width: 1
				border.color: "#888888"
				height: children[0].height + 2 * spacing
				anchors.horizontalCenter: parent.horizontalCenter
				
				ColumnLayout {
					spacing: spacing
					anchors.centerIn: parent
			
					RowLayout {
						id: bpmRow
						spacing: spacing
					
						NoteBox {id: bpmTypeBox}
						
						Label {text: "="}
						
						TextField {
							id: bpmField
							placeholderText: "120"
							implicitWidth: boxWidth
							validator: DoubleValidator {
								bottom: 1
								top: 999
								decimals: 2
								notation: DoubleValidator.StandardNotation
							}
						}//TextField
					}//RowLayout
					
					CheckBox {
						id: bpmParentheses
						checked: true
						text: qsTr("Add Parentheses")
					}
				}//ColumnLayout
			}//Rectangle
		}//ColumnLayout
		
		onRejected: {smartQuit()}
		onAccepted: {pushTempo()}
	}//Dialog
	
	function writeTempo() {
		var bpmNoteLength = bpmTypeBox.model.get(bpmTypeBox.currentIndex).fact
		var actBpm = Math.round(100 * parseFloat(bpmField.text) * bpmNoteLength / 4 / 60) / 100
		
		var style = curScore.style
		
		var expression = expressionField.text + ((bpmBox.checked || modulBox.checked) ? " " : "")
		
		var expressionStyle = {
			'fontFace' : ('<font face="' + style.value("tempoFontFace") + '"/>'),
			'fontStyle': (style.value("tempoFontStyle") == 1 ? "b" : (style.value("tempoFontStyle") == 2 ? "i" : false)),
				//add 3-6??
			'fontSize' : ('<font size="' + style.value("tempoFontSize") + '"/>')
		}
		
		var expressionText = (expression == " " || expression == "") ? ("") : (expressionStyle.fontFace + expressionStyle.fontSize +
			(expressionStyle.fontStyle ? ("<" + expressionStyle.fontStyle + ">") : "")
			+ expression + (expressionStyle.fontStyle ? ("</" + expressionStyle.fontStyle + ">") : ""))
			
		var metronomeStyle = {
			'fontFace' : ('<font face="' + style.value("metronomeFontFace") + '"/>'),
			'fontStyle': (style.value("metronomeFontStyle") == 1 ? "b" : (style.value("metronomeFontStyle") == 2 ? "i" : false)),
			'fontSize' : ('<font size="' + style.value("metronomeFontSize") + '"/>')
		}
			
		var modulationText = (modulBox.checked) ? (metronomeStyle.fontFace + metronomeStyle.fontSize
			+ (metronomeStyle.fontStyle ? ("<" + metronomeStyle.fontStyle + ">") : "")
			+ (modulParentheses.checked ? "(" : "") + modul1.model.get(modul1.currentIndex).display + " = "
			+ modul2.model.get(modul2.currentIndex).display + (modulParentheses.checked ? ")" : "")
			+ (metronomeStyle.fontStyle ? ("<" + metronomeStyle.fontStyle + ">") : "")) : ("")
		
		var bpmText = (bpmBox.checked) ? ((modulBox.checked ? " " : "") +  metronomeStyle.fontFace + metronomeStyle.fontSize
			+ (metronomeStyle.fontStyle ? ("<" + metronomeStyle.fontStyle + ">") : "")
			+ (bpmParentheses.checked ? "(" : "") + bpmTypeBox.model.get(bpmTypeBox.currentIndex).display + " = "
			+ (bpmField.text == "" ? bpmField.placeholderText : bpmField.text) + (bpmParentheses.checked ? ")" : "")
			+ (metronomeStyle.fontStyle ? ("<" + metronomeStyle.fontStyle + ">") : "")) : ("")
			
		var tempoText = expressionText + modulationText + bpmText
		console.log(tempoText)
		
		if (tempoText != "") {
			curScore.startCmd()
			var tempoElement = newElement(Element.TEMPO_TEXT)
			var addTempo = true
			if (curScore.selection.isRange) {
				cursor.rewind(Cursor.SELECTION_START)
			}
			var segment = cursor.segment
			for (var i in segment.annotations) {
				if (segment.annotations[i].type == Element.TEMPO_TEXT) {
					tempoElement = segment.annotations[i]
					addTempo = false
				}
			}
			addTempo = true
			tempoElement.sizeSpatiumDependent = (style.value("tempoFontSpatiumDependent") == 1)
			tempoElement.fontStyle = style.value("metronomeFontStyle")
			tempoElement.text = tempoText
			tempoElement.visible = true
			if (addTempo) {
				  cursor.add(tempoElement)
				  console.log("added new tempo to score")
			} else {console.log("modified existing tempo element")}
			//changing of tempo can only happen after being added to the segment
			tempoElement.tempo = actBpm
			tempoElement.followText = true
			curScore.endCmd()
		}
	}//writeTempo
	
	function pushTempo() {
		dialog.close()
		timer.start()
	}
	
	Timer {
		id: timer
		interval: 33 //ms
		repeat: true
		running: false
		onTriggered: {
			if (cursor.segment) {
				writeTempo()
				stop()
				smartQuit()
			}
		}
	}//Timer
	
	function smartQuit() {
		dialog.close()
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
	
	Settings {
		category: "NSM BPM Generator Plugin"
		property alias expressionField: expressionField.text
		property alias modulBox: modulBox.checked
		property alias modul1: modul1.currentIndex
		property alias modul2: modul2.currentIndex
		property alias modulParentheses: modulParentheses.checked
		property alias bpmBox: bpmBox.checked
		property alias bpmTypeBox: bpmTypeBox.currentIndex
		property alias bpmField: bpmField.text
		property alias bpmParentheses: bpmParentheses.checked
	}//Settings
}//MuseScore
