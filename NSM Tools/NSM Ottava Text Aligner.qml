import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	menuPath: "Plugins." + qsTr("NSM Tools") + "." + qsTr("Align 8va Text")
	description: qsTr("Vertically aligns the text of 8va markings") + "\n" +
		qsTr("Applies to selection only") + "\n" + qsTr("Requires MuseScore 3.3 or later")
	version: "1.0"
	requiresScore: true
	
	property real vAlignment: 0.25
	property var  gAlignment: "VCENTER" //musescore 4 needs an object here, but idk what parameters
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = qsTr("Align 8va Text")
        }
    }//Component
	
	onRun: {
		var ottavaCount = 0
		for (var i in curScore.selection.elements) {
			if (curScore.selection.elements[i].type == Element.OTTAVA || curScore.selection.elements[i].type == Element.OTTAVA_SEGMENT) {
				if (ottavaCount == 0) {curScore.startCmd()}
				fixOttava(curScore.selection.elements[i])
				ottavaCount += 1
			}
		}
		if (ottavaCount != 0) {curScore.endCmd()}
		console.log("changed " + ottavaCount + " ottavas")
		smartQuit()
	}//onRun
	
	function fixOttava(ottava) {
		console.log("ottava found")
		//how to check current properties
		//console.log(curScore.style.value("ottavaTextAlignAbove")) //mu4 only
		//console.log(curScore.style.value("ottavaTextAlignBelow")) //mu4 only
		//console.log(curScore.style.value("ottavaTextAlign")) //mu3 only
		//console.log(ottava.beginTextOffset)
		//console.log(ottava.ottavaType)
		//ottavaType: 0:8va 1:8vb 2:15ma 3:15mb 4:22ma 5:22mb
		var direction = (Math.round(ottava.ottavaType / 2) == ottava.ottavaType / 2) ? 1 : -1
		ottava.beginTextOffset.y    = vAlignment * direction
		ottava.continueTextOffset.y = vAlignment * direction
		if (mscoreMajorVersion < 4) {
			ottava.beginTextAlign    = gAlignment
			ottava.continueTextAlign = gAlignment
		} else {
			//curScore.style.setValue("ottavaTextAlignAbove", (0,1))
			//ottava.beginText = curScore.style.value("ottavaTextAlignAbove").toString()
		}
		console.log("fixed ottava")
	}
	
	function smartQuit() {
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
}//MuseScore
