import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	menuPath: "Plugins." + qsTr("NSM Tools") + "." + qsTr("Center Staccatos over notehead")
	description: qsTr("Centers stem-side staccatos over the notehead rather than the stem.") + "\n" +
		qsTr("Requires MuseScore 3.3 or later") + "\n" +
		qsTr("Currently non-functional in MuseScore 4")
	version: "1.0"
	requiresScore: true
	
	property var replacementArti: "Stress"
	//This plugin works by adding other articulations to notes with staccatos on them.
	//If you would rather use a different articulation type to do this, change the above var
	//Possible values:
	//"Accent", "AccentStaccato", "LaissezVibrer", "Marcato", "MarcatoStaccato",
	//"MarcatoTenuto", "SoftAccent", "SoftAccentStaccato", "SoftAccentTenuto",
	//"SoftAccentTenutoStaccato", "Staccatissimo", "StaccatissimoStroke",
	//"StaccatissimoWedge", ("Staccato"), "Stress", "Tenuto", "TenutoAccent",
	//"TenutoStaccato", "Unstress"
	
	property bool mode: true
	//true readjusts staccatos, false resets them to default position
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = qsTr("Center stem-side staccatos")
        }
    }//Component
	
	onRun: {
		var arti = newElement(Element.ARTICULATION)
		arti.symbol = "artic" + replacementArti + "Above"
		arti.visible = false
		arti.play = false
		
		var changelist = []
		
		if (curScore.selection.elements.length > 0) {
			curScore.startCmd()
			for (var i in curScore.selection.elements) {
				var element = curScore.selection.elements[i]
				if (element.type == Element.ARTICULATION) {
					//save ChordRests with articulation on them
					if (element.symbol.toString().includes("articStaccato")) {
						changelist.push(element.parent)
					}
					//remove articulations already present to avoid duplicates
					if (element.symbol.toString().includes("artic" + replacementArti) && ! element.visible && ! element.play) {
						removeElement(element)
					}
				}//if ARTICULATION
			}//for selection
			console.log("Found " + changelist.length + " staccato markings.")
			
			//We now have a complete list of notes with staccatos on them
			//Next we work our way through the score and find the notes again, and add articulation to them
			var cursor = curScore.newCursor()
			cursor.rewind(Cursor.SCORE_START)
			
			for (var j = 0; j < curScore.ntracks; j++) {
				cursor.rewindToTick(0)
				cursor.track = j
				console.log("At track " + cursor.track)
				
				while (mode) {
					if (cursor.element && cursor.element.type == Element.CHORD) {
						for (var i in changelist) {
							if (cursor.element.is(changelist[i])) {
								cursor.add(arti.clone())
								changelist.splice(i, 0)
								console.log("Adjusted staccato #" + i)
								break
							}//if we have a match
						}
					}
					if (! cursor.next()) {
						break
					}
				}//while staff
			}//for tracks
			
			curScore.endCmd()
		}//if selection
		smartQuit()
	}//onRun
	
	function smartQuit() {
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
}//MuseScore
