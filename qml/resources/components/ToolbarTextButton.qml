import Qt 4.7

Item {
    id: button
    property string label: ""
    property bool selected: false
    property bool shown: true
    property bool bar: false

    property string colorActive: theme.colors.textButtonText
    property string colorInactive: theme.colors.textButtonTextInactive
    signal clicked()
    width: buttonText.width + 10
    height: 58

    Item {
        anchors.fill: parent
        Text {
            id: buttonText
            text: button.label
            anchors.centerIn: parent
            color: selected ? colorActive : colorInactive
            font.pixelSize: theme.font.sizeToolbar
            font.family: "Nokia Pure" //theme.font.name
            font.bold: true
        }

        Rectangle {
            anchors.top: buttonText.bottom
            width: parent.width
            height: 6
            color: theme.colors.toolbarLightColor
            visible: selected && bar
        }

        visible: shown
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (shown) {
                button.clicked();
            }
        }
    }
}
