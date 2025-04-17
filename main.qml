import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    visible: true
    width: 1280
    height: 720

    title: qsTr("Car Dashboard")
    color: backgroundColor
    property int currentPage: 0
    property color backgroundColor: "#FFFFFF"

    function isLightColor(c) {
        let rgb = Qt.rgba(parseInt(c.r * 255), parseInt(c.g * 255), parseInt(c.b * 255), 1)
        let luminance = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b
        return luminance > 0.6
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            let now = new Date()
            timeLabel.text = Qt.formatTime(now, "hh:mm:ss")
            dateLabel.text = Qt.formatDate(now, "dd/MM/yyyy")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            spacing: 40

            Column {
                spacing: 4
                Text {
                    id: timeLabel
                    text: ""
                    color: isLightColor(backgroundColor) ? "black" : "white"
                    font.pixelSize: 32
                    font.bold: true
                }

                Text {
                    id: dateLabel
                    text: ""
                    color: isLightColor(backgroundColor) ? "black" : "white"
                    font.pixelSize: 18
                }
            }

            Item { Layout.fillWidth: true }
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: [dashboardPage, vehicleInfoPage, settingsPage][currentPage]
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: Qt.darker(backgroundColor, 1.2)
            radius: 10

            RowLayout {
                anchors.centerIn: parent
                spacing: 50

                Button {
                    text: "🏠 " + qsTr("Home Screen")
                    onClicked: currentPage = 0
                    font.pixelSize: 16
                }

                Button {
                    text: "🛠 " + qsTr("Vehicle Info")
                    onClicked: currentPage = 1
                    font.pixelSize: 16
                }

                Button {
                    text: "⚙ " + qsTr("Settings")
                    onClicked: currentPage = 2
                    font.pixelSize: 16
                }
            }
        }
    }

    // Dashboard Page
    Component {
        id: dashboardPage
        GridLayout {
            columns: 4
            anchors.margins: 40
            anchors.fill: parent
            rowSpacing: 40
            columnSpacing: 60

            Repeater {
                model: ListModel {
                    ListElement { name: qsTr("Radio"); icon: "qrc:/assets/images/car-radio.png" }
                    ListElement { name: qsTr("Television"); icon: "qrc:/assets/images/smart-tv.png" }
                    ListElement { name: qsTr("YouTube"); icon: "qrc:/assets/images/youtube.png" }
                    ListElement { name: qsTr("Maps"); icon: "qrc:/assets/images/google-maps.png" }
                    ListElement { name: qsTr("Home"); icon: "qrc:/assets/images/house.png" }
                    ListElement { name: qsTr("WhatsApp"); icon: "qrc:/assets/images/whatsapp.png" }
                    ListElement { name: qsTr("Phone"); icon: "qrc:/assets/images/phone-call.png" }
                    ListElement { name: qsTr("Settings"); icon: "qrc:/assets/images/setting.png" }
                }

                delegate: Column {
                    spacing: 10
                    width: 100
                    anchors.horizontalCenter: parent

                    Rectangle {
                        width: 80
                        height: 80
                        radius: 20
                        color: "#EEEEEE"
                        border.color: "#CCCCCC"
                        border.width: 1
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 60
                            height: 60
                            source: icon
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Clicked:", name)
                                if (name === qsTr("Settings")) {
                                    currentPage = 2
                                }
                            }
                        }
                    }

                    Text {
                        text: name
                        font.pixelSize: 16
                        color: isLightColor(backgroundColor) ? "black" : "white"
                        anchors.left: parent.left
                        anchors.leftMargin: 13
                        width: parent.width
                    }
                }
            }
        }
    }

    // Vehicle Information Page
    Component {
        id: vehicleInfoPage
        GridLayout {
            columns: 2
            columnSpacing: 30
            rowSpacing: 20
            anchors.centerIn: parent

            Text {
                text: qsTr("Speed")
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
            }
            Text {
                text: "120 km/h"
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
                font.bold: true
            }

            Text {
                text: qsTr("Fuel Level")
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
            }
            Text {
                text: "75%"
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
                font.bold: true
            }

            Text {
                text: qsTr("Engine Temperature")
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
            }
            Text {
                text: "85°C"
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
                font.bold: true
            }

            Text {
                text: qsTr("Tire Pressure")
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
            }
            Text {
                text: "32 PSI"
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 22
                font.bold: true
            }
        }
    }

    // Settings Page
    Component {
        id: settingsPage
        ColumnLayout {
            spacing: 20
            anchors.centerIn: parent

            Text {
                text: qsTr("Settings")
                color: isLightColor(backgroundColor) ? "black" : "white"
                font.pixelSize: 34
                font.bold: true
            }

            Text {
                text: qsTr("Language")
                font.pixelSize: 20
                color: isLightColor(backgroundColor) ? "black" : "white"
            }

            RowLayout {
                spacing: 10
                Repeater {
                    model: langManager.availableLanguages
                    delegate: Button {
                        text: modelData
                        onClicked: {
                            langManager.changeLanguage(modelData)
                            Qt.callLater(retranslate)
                        }
                    }
                }
            }

            Text {
                text: qsTr("Background Color")
                font.pixelSize: 20
                color: isLightColor(backgroundColor) ? "black" : "white"
            }

            RowLayout {
                spacing: 10

                ListModel {
                    id: colorModel
                    ListElement { colorName: qsTr("Dark"); colorValue: "#1E1E1E" }
                    ListElement { colorName: qsTr("Light"); colorValue: "#F5F5F5" }
                    ListElement { colorName: qsTr("Blue"); colorValue: "#0D47A1" }
                    ListElement { colorName: qsTr("Green"); colorValue: "#2E7D32" }
                }

                Repeater {
                    model: colorModel
                    delegate: Button {
                        text: model.colorName
                        onClicked: backgroundColor = model.colorValue
                    }
                }
            }
        }
    }

    function retranslate() {
        console.log("🌍 Retranslation complete")
    }

    Component.onCompleted: clockTimer.start()
}
