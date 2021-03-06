import Qt 4.7

Rectangle {
    id: checkin
    width: parent.width
    height: items.height + 20
    color: mytheme.colors.backgroundBlueDark
    state: "hidden"
    property string venueID: ""
    property string venueName: ""
    property bool useFacebook: false
    property bool useTwitter: false
    property bool useFriends: true
    signal cancel()
    signal checkin(string venueID, string comment, bool friends, bool facebook, bool twitter)

    function reset() {
        shoutText.text = mytheme.textDefaultComment;
    }

    function hideKeyboard() {
        shoutText.closeSoftwareInputPanel();
        window.focus = true;
    }

    Column {
        id: items
        x: 10
        y: 10
        width: parent.width - 20
        spacing: 10

        Text {
            id: venueName
            text: checkin.venueName
            width: parent.width
            font.pixelSize: 24
            color: mytheme.colors.textColorSign
        }

        Rectangle {
            id: checkinShoutBox
            height: 130
            width: parent.width
            gradient: mytheme.gradientTextBox
            border.width: 1
            border.color: mytheme.colors.textboxBorderColor
            smooth: true

            TextEdit {
                id: shoutText
                wrapMode: TextEdit.Wrap
                text: mytheme.textDefaultComment
                textFormat: TextEdit.PlainText
                width: parent.width - 10
                height: parent.height - 10
                x: 5
                y: 5
                color: mytheme.colors.textColor
                font.pixelSize: 24

                onTextChanged: {
                    if (text.length > 130) {
                        color = mytheme.colors.textColorAlarm;
                        if (text.length > 140) {
                            text = text.substring(0,140);
                            cursorPosition = 140;
                        }
                    } else {
                        if (text != mytheme.textDefaultComment)
                            color = mytheme.colors.textColor;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        shoutText.focus = true;
                        if(shoutText.text==mytheme.textDefaultComment) {
                            shoutText.text = "";
                        }
                        if (shoutText.text != "") {
                            shoutText.cursorPosition = shoutText.positionAt(mouseX,mouseY);
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            color: mytheme.colors.toolbarDarkColor
            height: 10 + friendsRow.y + friendsRow.height
            radius: 5
            smooth: true

            Row {
                id: friendsRow
                y: 10
                x: 10
                spacing: 10
                width: parent.width - 64
                height: 42

                Rectangle {
                    border.width: 1
                    border.color: mytheme.colors.checktapBorderColor
                    color: friendsMouseArea.pressed ? mytheme.colors.checktapBackgroundActive : mytheme.colors.checktapBackground
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/"+mytheme.name+"/checktap.png"
                        visible: checkin.useFriends
                    }

                    MouseArea {
                        id: friendsMouseArea
                        anchors.fill: parent
                        onClicked: {
                            checkin.useFriends = !checkin.useFriends;
                        }
                    }
                }

                Text {
                    text: "Friends"
                    wrapMode: Text.Wrap
                    font.pixelSize: mytheme.font.sizeSigns
                    anchors.verticalCenter: parent.verticalCenter
                    color: mytheme.colors.textColorSign
                }

                Rectangle {
                    border.width: 1
                    border.color: mytheme.colors.checktapBorderColor
                    color: facebookMouseArea.pressed ? mytheme.colors.checktapBackgroundActive : mytheme.colors.checktapBackground
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/"+mytheme.name+"/checktap.png"
                        visible: checkin.useFacebook
                    }

                    MouseArea {
                        id: facebookMouseArea
                        anchors.fill: parent
                        onClicked: {
                            checkin.useFacebook = !checkin.useFacebook;
                        }
                    }
                }

                Text {
                    text: "Facebook"
                    wrapMode: Text.Wrap
                    font.pixelSize: mytheme.font.sizeSigns
                    anchors.verticalCenter: parent.verticalCenter
                    color: mytheme.colors.textColorSign
                }


                Rectangle {
                    border.width: 1
                    border.color: mytheme.colors.checktapBorderColor
                    color: twitterMouseArea.pressed ? mytheme.colors.checktapBackgroundActive : mytheme.colors.checktapBackground
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/"+mytheme.name+"/checktap.png"
                        visible: checkin.useTwitter
                    }

                    MouseArea {
                        id: twitterMouseArea
                        anchors.fill: parent
                        onClicked: {
                            checkin.useTwitter = !checkin.useTwitter;
                        }
                    }
                }

                Text {
                    text: "Twitter"
                    wrapMode: Text.Wrap
                    font.pixelSize: mytheme.font.sizeSigns
                    anchors.verticalCenter: parent.verticalCenter
                    color: mytheme.colors.textColorSign
                }
            }
        }

        Item {
            width: parent.width
            height: checkinButton.height

            ButtonGreen {
                id: checkinButton
                label: "CHECK-IN HERE"
                width: parent.width - 130
                onClicked: {
                    hideKeyboard();
                    checkin.checkin( checkin.venueID, shoutText.text, checkin.useFriends, checkin.useFacebook, checkin.useTwitter )
                }
            }

            ButtonGray {
                label: "Cancel"
                x: parent.width - 120
                width: 120
                onClicked: {
                    hideKeyboard();
                    checkin.state = "hidden";
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
                target: checkin
                y: -200-checkin.height
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: checkin
                y: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "shown"
            SequentialAnimation {
                PropertyAnimation {
                    target: checkin
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
                PropertyAction {
                    target: checkin
                    properties: "visible"
                    value: false
                }
            }
        },
        Transition {
            to: "shown"
            SequentialAnimation {
                PropertyAction {
                    target: checkin
                    properties: "visible"
                    value: true
                }
                PropertyAnimation {
                    target: checkin
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
