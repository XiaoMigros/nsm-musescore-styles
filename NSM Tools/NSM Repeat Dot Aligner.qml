import QtQuick 2.0
import MuseScore 3.0

MuseScore {
    title: qsTr("Fix Finale Barlines")
    description: qsTr("Adjusts the position of repeat dots to their correct height, with Finale Maestro and Broadway fonts.")
        + "\n\n" + qsTr("Select any number of barlines, repeats or not, and run the plugin!")
        + "\n\n" + qsTr("Requires MuseScore 4 or later")
    version: "1.0"
    requiresScore: true

    onRun: {
        var adjust = (mscoreMajorVersion == 4 ? mscoreMinorVersion < 1 : mscoreMajorVersion < 3) ? 1 : 0
        curScore.startCmd()
        for (var e of curScore.selection.elements) {
            if (e.type == Element.BAR_LINE) {
                if (e.barlineType == 4 || e.barlineType == 8) {
                    e.offsetY = -0.5 * adjust
                    e.barlineSpanFrom = 1 * adjust
                    if (e.barlineSpan == 1 || e.barlineSpan == true) {
                        e.barlineSpanTo = -1 * adjust
                    } else {
                        e.barlineSpanTo = 1 * adjust
                    }
                }
            }
        }
        curScore.endCmd()
    }
}
