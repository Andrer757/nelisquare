import Qt 4.7
import com.nokia.meego 1.0
import "../build.info.js" as BuildInfo
import "../components"

//TODO: dont forget about PAGESTACK:

PageWrapper {
    signal authDeleted()

    signal settingsChanged(string type, string value);

    property string cacheSize: "updating..."

    id: settings
    color: mytheme.colors.backgroundMain

    width: parent.width
    height: parent.height

    tools: ToolBarLayout{
        ToolIcon{
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: {
                //TODO: add menu
                dummyMenu.open();
            }
        }
    }

    function load() {
        var page = settings;
        page.authDeleted.connect(function(){
            configuration.settingChanged("accesstoken","");
        });
        page.settingsChanged.connect(function(type,value) {
            configuration.settingChanged("settings."+type,value);
        });
        cacheUpdater.start();
    }

    Timer {
        id: cacheUpdater
        interval: 50
        repeat: false
        onTriggered: {
            cacheSize = cache.info();
        }
    }

    LineGreen {
        id: settingsLabel
        text: "SETTINGS"
        size: mytheme.font.sizeSettigs
        height: 50
    }

    Flickable{

        id: flickableArea
        anchors.top: settingsLabel.bottom
        width: parent.width
        contentWidth: parent.width
        height: settings.height - y

        clip: true
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        pressDelay: 100

        Column {
            onHeightChanged: {
                flickableArea.contentHeight = height + y;
            }

            width: parent.width - 20
            y: 30
            x: 10
            spacing: 0

            //Check updates
            Text {
                color: mytheme.colors.textColorOptions
                text: "Check for updates"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.checkupdates === "none"
                    label: "NONE"
                    onClicked: settingsChanged("checkupdates","none")
                }
                TextButton {
                    height: 35
                    selected: configuration.checkupdates === "stable"
                    label: "STABLE"
                    onClicked: settingsChanged("checkupdates","stable")
                }
                TextButton {
                    height: 35
                    selected: configuration.checkupdates === "developer"
                    label: "BETA"
                    onClicked: settingsChanged("checkupdates","developer")
                }
                TextButton {
                    height: 35
                    selected: configuration.checkupdates === "alpha"
                    label: "ALPHA"
                    onClicked: settingsChanged("checkupdates","alpha")
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //OrientationLock
            Text {
                color: mytheme.colors.textColorOptions
                text: "Screen orientation"
                font.pixelSize: mytheme.font.sizeSettigs
                visible: (configuration.platform === "maemo")
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.orientationType === "auto"
                    label: "AUTO"
                    onClicked: settingsChanged("orientation","auto")
                }
                TextButton {
                    height: 35
                    selected: configuration.orientationType === "landscape"
                    label: "LANDSCAPE"
                    onClicked: settingsChanged("orientation","landscape")
                }
                TextButton {
                    height: 35
                    selected: configuration.orientationType === "portrait"
                    label: "PORTRAIT"
                    onClicked: settingsChanged("orientation","portrait")
                }
                visible: (configuration.platform === "maemo")
            }

            Item{
                height: 20
                width: parent.width
            }

            //Map provider
            Text {
                color: mytheme.colors.textColorOptions
                text: "Map provider"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.mapprovider === "google"
                    label: "GOOGLE"
                    onClicked: settingsChanged("mapprovider","google")
                }
                TextButton {
                    height: 35
                    selected: configuration.mapprovider === "openstreetmap"
                    label: "OSM"
                    onClicked: settingsChanged("mapprovider","openstreetmap")
                }
                TextButton {
                    height: 35
                    selected: configuration.mapprovider === "nokia"
                    label: "NOKIA"
                    onClicked: settingsChanged("mapprovider","nokia")
                }

            }

            Item {
                height: 20
                width: parent.width
            }

            //Molome integration
            Text {
                color: mytheme.colors.textColorOptions
                text: "MOLO.me integration"
                font.pixelSize: mytheme.font.sizeSettigs
                visible: configuration.platform === "meego"
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    label: "DOWNLOAD MOLO.ME FIRST!"
                    onClicked: {
                        Qt.openUrlExternally("http://molo.me/meego");
                    }
                    visible: !window.molome_present;
                }

                TextButton {
                    height: 35
                    selected: true
                    label: (window.molome_installed ? "ENABLED" : "DISABLED")
                    onClicked: molome.updateinfo();
                    visible: window.molome_present;
                }
                TextButton {
                    height: 35
                    selected: false
                    label: "INSTALL"
                    onClicked: {
                        waiting.show();
                        selected = true;
                        molome.install();
                    }
                    visible: !window.molome_installed && window.molome_present;
                    onVisibleChanged: {
                        if (selected) {
                            waiting.hide();
                            selected = false;
                        }
                    }
                }
                TextButton {
                    height: 35
                    selected: false
                    label: "UNINSTALL"
                    onClicked: {
                        waiting.show();
                        selected = true;
                        molome.uninstall();
                    }
                    visible: window.molome_installed && window.molome_present;
                    onVisibleChanged: {
                        if (selected) {
                            waiting.hide();
                            selected = false;
                        }
                    }
                }
                visible: configuration.platform === "meego";
            }
            Item{
                height: 20
                width: parent.width
                visible: configuration.platform === "meego";
            }

            //Image loading settings
            Text {
                color: mytheme.colors.textColorOptions
                text: "Load images"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.imageLoadType === "cached"
                    label: "CACHED"
                    onClicked: settingsChanged("imageload","cached");
                }

                TextButton {
                    height: 35
                    selected: configuration.imageLoadType === "all"
                    label: "ALL"
                    onClicked: settingsChanged("imageload","all");
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //GPS Unlock time
            Text {
                color: mytheme.colors.textColorOptions
                text: "GPS Unlock timeout"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.gpsUplockTime === 0
                    label: "AT ONCE"
                    onClicked: settingsChanged("gpsunlock",0);
                }

                TextButton {
                    height: 35
                    selected: configuration.gpsUplockTime === 30
                    label: "30 SEC"
                    onClicked: settingsChanged("gpsunlock",30);
                }

                TextButton {
                    height: 35
                    selected: configuration.gpsUplockTime === 60
                    label: "60 SEC"
                    onClicked: settingsChanged("gpsunlock",60);
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            Text {
                color: mytheme.colors.textColorOptions
                text: "Feed autoupdate"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.feedAutoUpdate === 0
                    label: "OFF"
                    onClicked: settingsChanged("feedupdate",0);
                }

                TextButton {
                    height: 35
                    selected: configuration.feedAutoUpdate === 600
                    label: "10 MIN"
                    onClicked: settingsChanged("feedupdate",600);
                }

                TextButton {
                    height: 35
                    selected: configuration.feedAutoUpdate === 1800
                    label: "30 MIN"
                    onClicked: settingsChanged("feedupdate",1800);
                }

                TextButton {
                    height: 35
                    selected: configuration.feedAutoUpdate === 3600
                    label: "1 HOUR"
                    onClicked: settingsChanged("feedupdate", 3600);
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //Notifications
            Text {
                color: mytheme.colors.textColorOptions
                text: "Notification popups"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.feedNotification === "0"
                    label: "DISABLED"
                    onClicked: settingsChanged("feed.notification","0");
                }

                TextButton {
                    height: 35
                    selected: configuration.feedNotification === "1"
                    label: "ENABLED"
                    onClicked: settingsChanged("feed.notification","1");
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //Event feed integration
            Text {
                color: mytheme.colors.textColorOptions
                text: "Feed at Home screen"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: configuration.feedIntegration === "0"
                    label: "DISABLED"
                    onClicked: settingsChanged("feed.integration","0");
                }

                TextButton {
                    height: 35
                    selected: configuration.feedIntegration === "1"
                    label: "ENABLED"
                    onClicked: settingsChanged("feed.integration","1");
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //THEME
            Text {
                color: mytheme.colors.textColorOptions
                text: "Nelisquare theme"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: mytheme.name === "light"
                    label: "LIGHT"
                    onClicked: settingsChanged("theme","light");
                }

                TextButton {
                    height: 35
                    selected: mytheme.name === "dark"
                    label: "DARK"
                    onClicked: settingsChanged("theme","dark");
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //Image loading settings
            Text {
                color: mytheme.colors.textColorOptions
                text: "Push notifications"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: false//configuration.imageLoadType === "cached"
                    label: "ENABLED"
                    onClicked: {
                        pushNotificationDialog.state = "shown";
                    }
                }

                TextButton {
                    height: 35
                    selected: true//configuration.imageLoadType === "all"
                    label: "DISABLED"
                    onClicked: settingsChanged("push.enabled","0");
                }
            }
            Item{
                height: 20
                width: parent.width
            }

            //App cache
            Text {
                color: mytheme.colors.textColorOptions
                text: "App Cache"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width
                spacing: 20

                TextButton {
                    height: 35
                    selected: false
                    label: "RESET"
                    onClicked: {
                        cache.reset();
                        cacheSize = cache.info();
                    }
                }

                TextButton {
                    height: 35
                    selected: false
                    label: "Size: " + cacheSize;
                }
            }

            Item{
                height: 20
                width: parent.width
            }

            //Revoke auth token
            Text {
                color: mytheme.colors.textColorOptions
                text: "Reset authentication"
                font.pixelSize: mytheme.font.sizeSettigs
            }
            Row {
                width: parent.width

                TextButton {
                    height: 35
                    label: "REVOKE"
                    onClicked: {
                        authDeleted()
                    }
                }
            }

            Item{
                height: 20
                width: parent.width
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../pics/"+mytheme.name+"/separator.png"
            }

            Item{
                height: 20
                width: parent.width
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mytheme.textHelp1
                color: mytheme.colors.textColorOptions
                font.pixelSize: mytheme.font.sizeHelp

                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mytheme.textHelp2
                color: mytheme.colors.textColorOptions
                font.pixelSize: mytheme.font.sizeHelp
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mytheme.textVersionInfo + BuildInfo.version
                color: mytheme.colors.textColorOptions
                font.pixelSize: mytheme.font.sizeHelp
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mytheme.textBuildInfo + BuildInfo.build
                color: mytheme.colors.textColorOptions
                font.pixelSize: mytheme.font.sizeHelp
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mytheme.textHelp3
                color: mytheme.colors.textColorOptions
                font.pixelSize: mytheme.font.sizeHelp
                font.underline: true

                horizontalAlignment: Text.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally(mytheme.textHelp3);
                    }
                }
            }

            Item {
                width: parent.width
                height: 30
            }

        }
    }
}