import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	menuPath: "Plugins." + qsTr("NSM Tools") + "." + qsTr("Center stem-side staccatos over notehead")
	description: qsTr("Centers stem-side staccatos over the notehead rather than the stem.") + "\n" +
		qsTr("Requires MuseScore 3.5 or later")
	version: "2.0"
	requiresScore: true
	
	property bool mode: true
	//true centers staccatos, false resets them to default position
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) title = qsTr("Center stem-side staccatos over notehead")
    }//Component
	
	onRun: {
		var arti = newElement(Element.ARTICULATION)
		arti.symbol = (mscoreMajorVersion < 4) ? "space" : 2975 //symid enums not exposed in mu4
		arti.play = false
		arti.color = "transparent" //neither play nor transparent are really needed
		arti.visible = false
		
		var full = false
		if (curScore.selection.elements.length == 0) {
			full = true
			cmd('select-all')
		}
		
		curScore.startCmd()
		
		var changelist = []
		
		for (var i in curScore.selection.elements) {
			var element = curScore.selection.elements[i]
			if (element.type == Element.ARTICULATION) {
				//save ChordRests with articulation on them
				if (mscoreMajorVersion < 4 ? element.symbol.toString().includes("articStaccato") : //is 579, 578
					(element.symbol == 624 || element.symbol == 623)) { //is 624, 623
					changelist.push(element.parent)
				}
				//remove articulations already present to avoid duplicates (if they are playn't and invisible)
				if (element.symbol.toString() == arti.symbol.toString() && ! element.visible && ! element.play) {
					removeElement(element)
				}
			}//if ARTICULATION
		}//for selection
		console.log("Found " + changelist.length + " staccato markings.")
		
		//We now have a complete list of notes with staccatos on them
		//Next we work our way through the score and find the notes again, and add articulation to them
		var cursor = curScore.newCursor()
		
		for (var j = 0; j < curScore.ntracks; j++) {
			cursor.rewindToTick(0)
			cursor.track = j
			
			while (mode) {//only center staccatos if mode is true (we already reset their positions, L#46)
				if (cursor.element && cursor.element.type == Element.CHORD) {
					for (var i in changelist) {
						//if we have a match
						if (cursor.element.is(changelist[i])) {
							cursor.add(arti.clone())
							changelist.splice(i, 0)
							console.log("Adjusted staccato #" + Number(+i+1))
							break
						}
					}
				}
				if (! cursor.next()) {
					break
				}
			}//while staff
		}//for tracks
		if (full) curScore.selection.clear()
		curScore.endCmd()
		if (mscoreMajorVersion < 4) Qt.quit()
		else quit()
	}//onRun
}//MuseScore
