{ config, pkgs, lib, ... }:

let
  fixScript = pkgs.writeShellScript "bt-headset-fix" ''
    export PATH="${lib.makeBinPath [ pkgs.coreutils pkgs.pipewire pkgs.pulseaudio pkgs.python3 ]}:$PATH"

    HEADSET_NAME="WH-CH720N"
    BUILTIN_MIC="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"
    LOG=/tmp/bt-headset-fix.log

    log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG"; }

    while true; do
      # 1. Never let the BT headset drop into hands-free (HFP) mode - it silences game audio.
      card=$(pactl list cards | awk -v want="$HEADSET_NAME" '
        /^Card #/{card=""; desc=""}
        /Name: bluez_card/{card=$2}
        /device.description/{d=$0; sub(/.*device.description = "/,"",d); sub(/".*$/,"",d); desc=d}
        /Active Profile: headset-head-unit/ && desc==want {print card}
      ')
      if [ -n "$card" ]; then
        pactl set-card-profile "$card" a2dp-sink 2>/dev/null
        log "$card -> a2dp-sink"
      fi

      # 2. Route Minecraft + Discord microphones to the built-in laptop mic.
      mic_id=$(pactl list sources short | awk '/HiFi__Mic1__source/{print $1; exit}')
      pactl list source-outputs | awk -v mic="$mic_id" '
        /^Source Output #/{if(so!="" && (name=="java"||name=="vesktop") && src!="" && src!=mic) print so; so=$3; name=""; src=""; next}
        /application.name/{name=$3; gsub(/"/,"",name)}
        /Source:/{src=$2}
        END{if(so!="" && (name=="java"||name=="vesktop") && src!="" && src!=mic) print so}
      ' | sort -u | while read -r so; do
        pactl move-source-output "$so" "$BUILTIN_MIC" 2>/dev/null
        log "source-output $so -> built-in mic"
      done

      # 3. Unmute Minecraft playback (a system-level mute was silencing the game).
      pactl list sink-inputs | awk '
        /^Sink Input #/{id=$3; muted=0}
        /Mute: yes/{muted=1}
        /node.name = "java"/ && muted {print id}
      ' | while read -r si; do
        pactl set-sink-input-mute "$si" 0 2>/dev/null
        log "unmuted sink-input $si"
      done

      # 4. Default capture device = laptop mic.
      pactl set-default-source "$BUILTIN_MIC" 2>/dev/null

      # 5. Safety net at the PipeWire level: re-route any app stream that got
      #    wired to the headset mic (covers mono voice-chat streams that pactl
      #    cannot move) straight to the laptop mic.
      pw-dump 2>/dev/null | python3 -c '
import json, subprocess, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
nodes = {o["id"]: o for o in d if o["type"] == "PipeWire:Interface:Node"}
mic = next((o for o in d if o["type"] == "PipeWire:Interface:Node"
            and o["info"]["props"].get("media.class") == "Audio/Source"
            and "Mic1" in o["info"]["props"].get("node.name", "")), None)
if mic is None:
    sys.exit(0)
cap = {}
for p in d:
    if p["type"] != "PipeWire:Interface:Port":
        continue
    pr = p["info"]["props"]
    if pr.get("node.id") == mic["id"] and pr.get("port.direction") == "out":
        cap[pr.get("port.name")] = p["id"]
bluez_srcs = {o["id"] for o in d if o["type"] == "PipeWire:Interface:Node"
              and o["info"]["props"].get("media.class") == "Audio/Source"
              and o["info"]["props"].get("node.name", "").startswith("bluez_input")}
for o in d:
    if o["type"] != "PipeWire:Interface:Link":
        continue
    pr = o["info"]["props"]
    try:
        outn, inn = int(pr.get("link.output.node")), int(pr.get("link.input.node"))
    except (TypeError, ValueError):
        continue
    if outn not in bluez_srcs:
        continue
    props = nodes.get(inn, {}).get("info", {}).get("props", {})
    if props.get("media.class") != "Stream/Input/Audio" or props.get("node.name") not in ("java", "vesktop"):
        continue
    subprocess.run(["pw-link", "-d", str(o["id"])])
    inports = sorted(
        (p for p in d if p["type"] == "PipeWire:Interface:Port"
         and p["info"]["props"].get("node.id") == inn
         and p["info"]["props"].get("port.direction") == "in"),
        key=lambda p: p["info"]["props"].get("port.id", 0))
    for i, ip in enumerate(inports[:2]):
        src = cap.get("capture_FL" if i == 0 else "capture_FR")
        if src is not None:
            subprocess.run(["pw-link", str(src), str(ip["id"])])
    print("relinked stream", inn, "to built-in mic", flush=True)
' >> "$LOG" 2>&1

      sleep 3
    done
  '';
in
{
  systemd.user.services.bt-headset-fix = {
    Unit = {
      Description = "Keep WH-CH720N on A2DP stereo and route game/Discord mics to the laptop mic";
      After = [ "graphical-session.target" "wireplumber.service" ];
    };
    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      ExecStart = fixScript;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
