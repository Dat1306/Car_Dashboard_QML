import QtQuick 2.15
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import Qt.labs.platform 1.1
import QtQuick.Controls 2.15
import QtQml 2.15
import QtQuick.Window 2.15

QtObject {
    id: settingsManager
    property string language: "en"
    property string backgroundColor: "#FFFFFF"

    function loadSettings() {
        const filePath = StandardPaths.writableLocation(StandardPaths.AppDataLocation) + "/settings.json"
        if (!File.exists(filePath)) {
            console.log("⚠ Settings file not found:", filePath)
            return
        }
        const file = File.read(filePath)
        const obj = JSON.parse(file)
        language = obj.language || "en"
        backgroundColor = obj.backgroundColor || "#FFFFFF"
    }

    function saveSettings() {
        const filePath = StandardPaths.writableLocation(StandardPaths.AppDataLocation) + "/settings.json"
        const obj = {
            language: language,
            backgroundColor: backgroundColor
        }
        File.write(filePath, JSON.stringify(obj))
    }

    QtObject {
        id: File

        function exists(path) {
            try {
                return Qt.openUrlExternally("file://" + path)
            } catch (e) {
                return false
            }
        }

        function read(path) {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + path, false)
            xhr.send()
            return xhr.responseText
        }

        function write(path, data) {
            var xhr = new XMLHttpRequest()
            xhr.open("PUT", "file://" + path, false)
            xhr.send(data)
        }
    }
}
