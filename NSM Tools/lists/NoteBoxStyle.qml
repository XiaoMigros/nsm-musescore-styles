import QtQuick 2.0
import QtQuick.Controls.Styles 1.3

ComboBoxStyle {
	textColor: '#000000'
	selectedTextColor: '#000000'
	font.family: (mscoreMajorVersion >= 4) ? ('Finale Maestro Text') : ('Bravura Text')
	font.pointSize: (mscoreMajorVersion >= 4) ? 14 : 16
	padding.top: 2
	padding.bottom: (mscoreMajorVersion >= 4) ? 2 : 0
	padding.right: (mscoreMajorVersion >= 4) ? 2 : 0
	padding.left: (mscoreMajorVersion >= 4) ? 2 : 0
}
