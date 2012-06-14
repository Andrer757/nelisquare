import Qt 4.7
import "."

Rectangle {
    id: photoShare
    width: parent.width
    height: items.height + 20
    color: theme.toolbarLightColor

    signal cancel()
    signal uploadPhoto(string photo, bool makepublic, bool facebook, bool twitter)

    property string photoUrl: ""
    property bool useFacebook: false
    property bool useTwitter: false
    property bool useVenue: false
    property bool makePublic: false

    onPhotoUrlChanged: {
        selectedPhoto.photoUrl = photoShare.photoUrl
    }

    function reset() {
    }

    Column {
        id: items
        x: 10
        y: 10
        width: parent.width - 20
        spacing: 10

        Text {
            text: "Selected photo"
            width: parent.width
            font.pixelSize: 24
            color: "#fff"
        }

        Row {
            width: parent.width
            spacing: 10

            ProfilePhoto {
                id: selectedPhoto
                anchors.verticalCenter: parent.verticalCenter
                photoAspect: Image.PreserveAspectFit
                photoBorder: 2
                photoSize: 240
            }

            Rectangle {
                width: parent.width - selectedPhoto.width - parent.spacing
                color: theme.toolbarDarkColor
                border.color: "#2774aA"
                border.width: 1
                height: 10 + twitterRow.y + twitterRow.height
                radius: 5
                smooth: true

                Row {
                    id: friendsRow
                    y: 10
                    x: 10
                    spacing: 10
                    width: parent.width
                    height: 42

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: friendsMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/"+window.iconset+"/delete.png"
                            visible: photoShare.makePublic
                        }
                    }

                    Text {
                        text: "Make public"
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#fff"
                    }
                    MouseArea {
                        id: friendsMouseArea
                        anchors.fill: parent
                        onClicked: {
                            photoShare.makePublic = !photoShare.makePublic;
                        }
                    }
                }

                Row {
                    id: facebookRow
                    y: 20 + 42
                    x: 10
                    spacing: 10
                    width: parent.width
                    height: 42

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: facebookMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/"+window.iconset+"/delete.png"
                            visible: photoShare.useFacebook
                        }
                    }

                    Text {
                        text: "Facebook"
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#fff"
                    }

                    MouseArea {
                        id: facebookMouseArea
                        anchors.fill: parent
                        onClicked: {
                            photoShare.useFacebook = !photoShare.useFacebook;
                        }
                    }
                }

                Row {
                    y: 30 + 42*2
                    x: 10
                    id: twitterRow
                    spacing: 10
                    width: parent.width - 64
                    height: 42

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: twitterMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/"+window.iconset+"/delete.png"
                            visible: photoShare.useTwitter
                        }
                    }

                    Text {
                        text: "Twitter"
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#fff"
                    }

                    MouseArea {
                        id: twitterMouseArea
                        anchors.fill: parent
                        onClicked: {
                            photoShare.useTwitter = !photoShare.useTwitter;
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: checkinButton.height

            GreenButton {
                id: checkinButton
                label: "Upload photo"
                width: parent.width - 130
                onClicked: photoShare.uploadPhoto( photoUrl, makePublic, useVenue, useFacebook, useTwitter )

            }

            GreenButton {
                label: "Cancel"
                x: parent.width - 120
                width: 120
                onClicked: photoShare.cancel();
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
                target: photoShare
                y: -photoShare.height
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: photoShare
                y: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "shown"
            SequentialAnimation {
                PropertyAnimation {
                    target: photoShare
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
                PropertyAction {
                    target: photoShare
                    properties: "visible"
                    value: false
                }
            }
        },
        Transition {
            to: "shown"
            SequentialAnimation {
                PropertyAction {
                    target: photoShare
                    properties: "visible"
                    value: true
                }
                PropertyAnimation {
                    target: photoShare
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}