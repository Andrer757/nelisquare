import Qt 4.7

Rectangle {
    id: update
    width: parent.width
    height: items.height + 20
    color: mytheme.colors.backgroundBlueDark
    state: "hidden"
    property string version: ""
    property string build: ""
    property string url: ""
    property string changelog: ""

    Column {
        id: items
        x: 10
        y: 10
        width: parent.width - 20
        spacing: 10

        Text {
            text: "New update is available!"
            width: parent.width
            font.pixelSize: mytheme.font.sizeSettigs
            color: mytheme.colors.textHeader
        }

        Text {
            text: "Version: " + update.version;
            width: parent.width
            font.pixelSize: mytheme.font.sizeDefault
            color: mytheme.colors.textHeader
        }

        Row {
            width: parent.width
            spacing: 20

            Text {
                text: "Type: " + configuration.checkupdates;
                //width: parent.width
                font.pixelSize: mytheme.font.sizeDefault
                color: mytheme.colors.textHeader
            }
            Text {
                text: "Build: " + update.build;
                //width: parent.width
                font.pixelSize: mytheme.font.sizeDefault
                color: mytheme.colors.textHeader
            }
        }

        Text {
            text: "Changelog: \n" + update.changelog;
            width: parent.width
            font.pixelSize: mytheme.font.sizeSigns
            color: mytheme.colors.textHeader
            visible: update.changelog.length>0
        }

        Item {
            width: parent.width
            height: updateButton.height

            ButtonGreen {
                id: updateButton
                label: "Update!"
                width: parent.width - 130
                onClicked: {
                    update.state = "hidden";
                    Qt.openUrlExternally(url);
                    Qt.quit();
                }
            }

            ButtonGray {
                label: "Cancel"
                x: parent.width - 120
                width: 120
                onClicked: {
                    update.state = "hidden";
                }
            }
        }
    }

    Image {
        id: shadow
        source: "../pics/top-shadow.png"
        width: parent.width
        y: parent.height - 1
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: update
                y: -200-update.height
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: update
                y: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "shown"
            SequentialAnimation {
                PropertyAnimation {
                    target: update
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
                PropertyAction {
                    target: update
                    properties: "visible"
                    value: false
                }
            }
        },
        Transition {
            to: "shown"
            SequentialAnimation {
                PropertyAction {
                    target: update
                    properties: "visible"
                    value: true
                }
                PropertyAnimation {
                    target: update
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
