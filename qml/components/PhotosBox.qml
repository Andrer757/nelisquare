import Qt 4.7

Item {
    signal itemSelected(string object)
    id: photosBoxComponent
    width: parent.width

    property string caption: "Photos"
    property int photoSize: 200
    property int fontSize: 20

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

        LineGreen {
            text: caption
            height: 30
            size: fontSize
        }

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

    Component {
        id: photoDelegate

        ProfilePhoto {
            photoUrl: model.photoThumb
            photoCache: true
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
