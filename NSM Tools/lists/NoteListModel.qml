import QtQuick 2.0

ListModel {
	ListElement {text: "\uECA0";               fact: 2;        display: "<sym>metNoteDoubleWhole</sym>"} // 2/1
	ListElement {text: "\uECA2";               fact: 1;        display: "<sym>metNoteWhole</sym>"} // 1/1
	ListElement {text: "\uECA3 \uECB7 \uECB7"; fact: 0.875;    display: "<sym>metNoteHalfUp</sym><sym>metAugmentationDot</sym><sym>metAugmentationDot</sym>"} // 1/2..
	ListElement {text: "\uECA3 \uECB7";        fact: 0.75;     display: "<sym>metNoteHalfUp</sym><sym>metAugmentationDot</sym>"} // 1/2.
	ListElement {text: "\uECA3";               fact: 0.5;      display: "<sym>metNoteHalfUp</sym>"} // 1/2
	ListElement {text: "\uECA5 \uECB7 \uECB7"; fact: 0.4375;   display: "<sym>metNoteQuarterUp</sym><sym>metAugmentationDot</sym><sym>metAugmentationDot</sym>"} // 1/4..
	ListElement {text: "\uECA5 \uECB7";        fact: 0.375;    display: "<sym>metNoteQuarterUp</sym><sym>metAugmentationDot</sym>"} // 1/4.
	ListElement {text: "\uECA5";               fact: 0.25;     display: "<sym>metNoteQuarterUp</sym>"} // 1/4
	ListElement {text: "\uECA7 \uECB7 \uECB7"; fact: 0.21875;  display: "<sym>metNote8thUp</sym><sym>metAugmentationDot</sym><sym>metAugmentationDot</sym>"} // 1/8..
	ListElement {text: "\uECA7 \uECB7";        fact: 0.1875;   display: "<sym>metNote8thUp</sym><sym>metAugmentationDot</sym>"} // 1/8.
	ListElement {text: "\uECA7";               fact: 0.125;    display: "<sym>metNote8thUp</sym>"} // 1/8
	ListElement {text: "\uECA9 \uECB7 \uECB7"; fact: 0.109375; display: "<sym>metNote16thUp</sym><sym>metAugmentationDot</sym><sym>metAugmentationDot</sym>"} //1/16..
	ListElement {text: "\uECA9 \uECB7";        fact: 0.09375;  display: "<sym>metNote16thUp</sym><sym>metAugmentationDot</sym>"} //1/16.
	ListElement {text: "\uECA9";               fact: 0.0625;   display: "<sym>metNote16thUp</sym>"} //1/16
}
