{ config, pkgs, inputs, ... }:
{
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
  ];

  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import Quickshell.Hyprland
    import QtQuick
    import QtQuick.Layouts

    Scope { id: root

      // ============================================================
      // ROSE PINE
      // ============================================================

      property color base: "#191724"
      property color surface: "#1f1d2e"
      property color overlay: "#26233a"
      property color muted: "#6e6a86"
      property color subtle: "#908caa"
      property color text: "#e0def4"
      property color love: "#eb6f92"
      property color gold: "#f6c177"
      property color rose: "#ebbcba"
      property color pine: "#31748f"
      property color foam: "#9ccfd8"
      property color iris: "#c4a7e7"
      property color highlightLow: "#21202e"
      property color highlightMed: "#403d52"
      property color highlightHigh: "#524f67"


      // ============================================================
      // GLOBAL WORKSPACE MODEL
      // ============================================================

      // Always show workspaces 1-10.
      //
      // This deliberately does NOT care which monitor owns a
      // workspace. The indicator is therefore global.

      property var workspaceList: [
        { id: 1 },
        { id: 2 },
        { id: 3 },
        { id: 4 },
        { id: 5 },
        { id: 6 },
        { id: 7 },
        { id: 8 },
        { id: 9 },
        { id: 10 }
      ]


      // ============================================================
      // BAR
      // ============================================================

      Variants {
        model: Quickshell.screens

        delegate: Component {

          PanelWindow {
            required property var modelData

            id: bar

            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true

            implicitHeight: 40

            color: root.base


            // ======================================================
            // CPU
            // ======================================================

            property int cpuUsage: 0

            property var lastCpuIdle: 0
            property var lastCpuTotal: 0

            Process {
              id: cpuProc

              command: [
                "sh",
                "-c",
                "head -1 /proc/stat"
              ]

              stdout: SplitParser {

                onRead: data => {
                  var p = data.trim().split(/\s+/)

                  var idle =
                    parseInt(p[4]) +
                    parseInt(p[5])

                  var total =
                    p.slice(1, 8).reduce(
                      (a, b) => a + parseInt(b),
                      0
                    )

                  if (bar.lastCpuTotal > 0) {

                    bar.cpuUsage = Math.round(
                      100 *
                      (
                        1 -
                        (
                          (idle - bar.lastCpuIdle) /
                          (total - bar.lastCpuTotal)
                        )
                      )
                    )
                  }

                  bar.lastCpuTotal = total
                  bar.lastCpuIdle = idle
                }
              }

              Component.onCompleted: {
                running = true
              }
            }


            // ======================================================
            // MEMORY
            // ======================================================

            property int memUsage: 0

            Process {
              id: memProc

              command: [
                "sh",
                "-c",
                "free | grep Mem"
              ]

              stdout: SplitParser {

                onRead: data => {

                  var parts =
                    data.trim().split(/\s+/)

                  var total =
                    parseInt(parts[1]) || 1

                  var used =
                    parseInt(parts[2]) || 0

                  bar.memUsage =
                    Math.round(
                      100 * used / total
                    )
                }
              }

              Component.onCompleted: {
                running = true
              }
            }


            // ======================================================
            // BATTERY
            // ======================================================

            property int battery: 0

            Process {
              id: batteryProc

              command: [
                "cat",
                "/sys/class/power_supply/BAT0/capacity"
              ]

              stdout: SplitParser {

                onRead: data => {
                  bar.battery =
                    parseInt(data.trim()) || 0
                }
              }

              Component.onCompleted: {
                running = true
              }
            }


            // ======================================================
            // SYSTEM UPDATE TIMER
            // ======================================================

            Timer {
              interval: 2000

              running: true
              repeat: true

              onTriggered: {
                cpuProc.running = true
                memProc.running = true
                batteryProc.running = true
              }
            }


            // ======================================================
            // HYPRLAND WORKSPACE UPDATES
            // ======================================================

            Connections {
              target: Hyprland

              function onFocusedWorkspaceChanged() {
                // The workspace's "focused" property updates
                // reactively, so this signal causes the Repeater
                // to reevaluate its colors.
              }

              function onWorkspacesChanged() {
                // Workspace creation/destruction can change
                // the objects exposed by Hyprland.
              }

              function onRawEvent(event) {

                if (
                  event.name === "workspace" ||
                  event.name === "focusedmon" ||
                  event.name === "createworkspace" ||
                  event.name === "destroyworkspace" ||
                  event.name === "moveworkspace" ||
                  event.name === "renameworkspace"
                ) {
                  Hyprland.refreshWorkspaces()
                }
              }
            }


            // ======================================================
            // BAR LAYOUT
            // ======================================================

            RowLayout {
              anchors.fill: parent

              anchors.margins: 8

              spacing: 8


              // ==================================================
              // NixOS
              // ==================================================

              Text {
                text: "NixOS"

                color: root.iris

                font {
                  pixelSize: 14
                  bold: true
                }
              }


              // ==================================================
              // WORKSPACES
              // ==================================================

              Repeater {

                model: root.workspaceList

                delegate: Text {

                  required property var modelData

                  property int workspaceId:
                    modelData.id

                  property bool isFocused:
                    Hyprland.focusedWorkspace !== null &&
                    Hyprland.focusedWorkspace.id === workspaceId

                  text: workspaceId

                  color:
                    isFocused
                      ? root.love
                      : root.text

                  font {
                    pixelSize: 14
                    bold: true
                  }

                  // Small gap between workspace numbers
                  Layout.leftMargin:
                    workspaceId === 1 ? 0 : 2
                }
              }


              // ==================================================
              // LEFT SPACER
              // ==================================================

              Item {
                Layout.fillWidth: true
              }


              // ==================================================
              // CLOCK
              // ==================================================

              Text {
                id: clock

                text:
                  Qt.formatDateTime(
                    new Date(),
                    "ddd, MMM dd - h:mm AP"
                  )

                color: root.text

                font {
                  pixelSize: 14
                  bold: true
                }

                Timer {

                  interval: 1000

                  running: true

                  repeat: true

                  onTriggered: {

                    clock.text =
                      Qt.formatDateTime(
                        new Date(),
                        "ddd, MMM dd - h:mm AP"
                      )
                  }
                }
              }


              // ==================================================
              // RIGHT SPACER
              // ==================================================

              Item {
                Layout.fillWidth: true
              }


              // ==================================================
              // CPU
              // ==================================================

              Text {

                text:
                  "CPU: " +
                  bar.cpuUsage +
                  "%"

                color:
                  bar.cpuUsage >= 75
                    ? root.love
                    : bar.cpuUsage >= 50
                      ? root.gold
                      : root.text

                font {
                  pixelSize: 14
                  bold: true
                }
              }


              // ==================================================
              // MEMORY
              // ==================================================

              Text {

                text:
                  "MEM: " +
                  bar.memUsage +
                  "%"

                color:
                  bar.memUsage >= 75
                    ? root.love
                    : bar.memUsage >= 50
                      ? root.gold
                      : root.text

                font {
                  pixelSize: 14
                  bold: true
                }
              }


              // ==================================================
              // BATTERY
              // ==================================================

              Text {

                text:
                  "BAT: " +
                  bar.battery +
                  "%"

                color:
                  bar.battery <= 20
                    ? root.love
                    : root.text

                font {
                  pixelSize: 14
                  bold: true
                }
              }
            }
          }
        }
      }
    }
  '';
}
