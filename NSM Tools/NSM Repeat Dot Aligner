import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	title: qsTr("Fix Finale Barlines")
	description: qsTr("Adjusts the position of repeat dots to their correct height, with Finale Maestro and Broadway fonts.")
		+ "\n\n" + qsTr("Select any number of barlines, repeats or not, and run the plugin!")
		+ "\n\n" + qsTr("Requires MuseScore 4.0.0 or later")
	version: "1.0"
	requiresScore: true
	
	onRun: {
		curScore.startCmd()
		for (var i in curScore.selection.elements) {
			if (curScore.selection.elements[i].type == Element.BAR_LINE) {
				if (curScore.selection.elements[i].barlineType == 4 || curScore.selection.elements[i].barlineType == 8) {
					curScore.selection.elements[i].offsetY = -0.5
					curScore.selection.elements[i].barlineSpanFrom = 1
					curScore.selection.elements[i].barlineSpanTo = 1
					if (curScore.selection.elements[i].barlineSpan == 1 || curScore.selection.elements[i].barlineSpan == true) {
						curScore.selection.elements[i].barlineSpanTo = -1
					}//weird rule
				}//if repeat
			}//if Barline
		}//for selection
		curScore.endCmd()
	}//onRun
}//MuseScore
