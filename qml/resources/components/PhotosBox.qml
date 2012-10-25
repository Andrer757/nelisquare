import Qt 4.7

Item {
    signal itemSelected(string object)
    id: photosBoxComponent
    width: parent.width

    property string caption: "Photos"
    property bool showButtons: false//true
    property int photoSize: photosBoxComponent.sizeMini
    property int fontSize: 20

    property int sizeMini: 150
    property int sizeMidi: 220
    property int sizeMaxi: 300

    property alias photosModel: photosModel

    ListModel {
        id: photosModel
    }

    Column {
        id: photoColumn
        width: parent.width
        onHeightChanged: {
            photosBoxComponent.height = height;
        }

        GreenLine {
            text: caption
            height: 30
            size: fontSize
        }

        /*Text {
            id: photoAreaCaption
            width: parent.width
            height: 48
            text: caption
            font.pixelSize: fontSize
        }*/

        ListView {
            width: parent.width
            height: photoSize + 10
            orientation: ListView.Horizontal
            boundsBehavior: ListView.StopAtBounds
            spacing: 5
            clip: true
            model: photosModel
            delegate: photoDelegate
        }
    }

    Row {
        anchors.right: photoColumn.right
        anchors.top: photoColumn.top

        ToolbarButton {
            width: 48
            height: 48
            image: "zoom_minus.png"
            selected: photosBoxComponent.photoSize == sizeMini;
            onClicked: {
                photosBoxComponent.photoSize = sizeMini;
            }
        }
        ToolbarButton {
            width: 48
            height: 48
            image: "zoom.png"
            selected: photosBoxComponent.photoSize == sizeMidi;
            onClicked: {
                photosBoxComponent.photoSize = sizeMidi;
            }
        }
        ToolbarButton {
            width: 48
            height: 48
            image: "zoom_plus.png"
            selected: photosBoxComponent.photoSize == sizeMaxi;
            onClicked: {
                photosBoxComponent.photoSize = sizeMaxi;
            }
        }
        visible: showButtons
    }

    Component {
        id: photoDelegate

        ProfilePhoto {
            photoUrl: model.photoThumb
            photoCache: false
            photoSize: photosBoxComponent.photoSize
            //photoAspect: Image.PreserveAspectCrop
            //enableMouseArea: false
            onClicked: {
                photosBoxComponent.itemSelected(model.objectID);
            }
        }
    }

    visible: photosModel.count>0
}
