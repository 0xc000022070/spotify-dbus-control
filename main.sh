#!/bin/sh

DESTINY="org.mpris.MediaPlayer2.spotify"
MESSAGE_PATH="/org/mpris/MediaPlayer2"

get_raw_position() {
    dbus-send --print-reply \
        --dest="$DESTINY" "/org/mpris/MediaPlayer2" \
        "org.freedesktop.DBus.Properties.Get" string:"org.mpris.MediaPlayer2.Player" string:"Position" |
        sort -r | head -n 1 | awk '{print $3}'
}

get_raw_track_id() {
    dbus-send --print-reply \
        --dest="$DESTINY" "/org/mpris/MediaPlayer2" \
        "org.freedesktop.DBus.Properties.Get" string:"org.mpris.MediaPlayer2.Player" string:"Metadata" |
        grep --after-context=1 'mpris:trackid' | sort -r | head -n 1 | awk -F'"' '{print $2}'
}

set_position() {
    new_position="$1"

    dbus-send --print-reply --dest="$DESTINY" /org/mpris/MediaPlayer2 \
        org.mpris.MediaPlayer2.Player.SetPosition "objpath:$(get_raw_track_id)" "int64:$new_position"
}

send_command_via_dbus() {
    name="$1"

    dbus-send --print-reply --dest="$DESTINY" "$MESSAGE_PATH" "org.mpris.MediaPlayer2.Player.$name"
}

PROGRAM_NAME="spotify-dbus"

main() {
    case "$1" in
    --next)
        send_command_via_dbus "Next"
        ;;
    --prev)
        send_command_via_dbus "Previous"
        ;;
    --toggle)
        send_command_via_dbus "PlayPause"
        ;;
    --stop)
        send_command_via_dbus "Stop"
        ;;
    --push-back)
        position=$(get_raw_position)

        x="1000000"
        new_position=$(((position / x - 5) * x))

        set_position "$new_position"
        ;;

    --push-forward)
        position=$(get_raw_position)

        x="1000000"
        new_position=$(((position / x + 5) * x))

        set_position "$new_position"
        ;;
    *)
        echo "$PROGRAM_NAME <flag>"
        echo
        echo "Flags:"
        echo " --next            Go to the next song"
        echo " --prev            Go to the previous song"
        echo " --toggle          Play or pause the current song"
        echo " --push-back       Go back 5 seconds"
        echo " --push-forward    Go forward 5 seconds"
        echo " --stop            Just stop"
        exit 1
        ;;
    esac
}

main "$@"
