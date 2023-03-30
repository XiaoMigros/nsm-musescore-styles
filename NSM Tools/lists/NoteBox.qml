import QtQuick 2.0
import QtQuick.Controls 1.1

ComboBox {
	height: boxHeight
	implicitWidth: boxWidth
	currentIndex: 7
	model: NoteListModel {}
	style: NoteBoxStyle {}
}