#!/bin/bash

if ! command -v swaymsg >/dev/null 2>&1; then
    echo "swaymsg is not installed." >&2
    exit 1
fi

INPUTS="$(swaymsg -t get_inputs 2>/dev/null)"

if [ -z "$INPUTS" ]; then
    echo "Sway is not running or inputs are unavailable." >&2
    exit 1
fi

LAYOUT="tr"
VARIANT="alt"
MODEL="pc105"
OPTIONS="caps:escape,altwin:ctrl_alt_win,grp:rctrl_switch"
MESSAGE="Applied internal (ISO) settings"

# Apple keyboard "Cem" / Apple keyboards
if printf '%s' "$INPUTS" | grep -Eqi "Cem|Apple"; then
    MODEL="applealu_ansi"
    OPTIONS="caps:escape,ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl,lv3:menu_switch"
    MESSAGE="Applied Apple (Cem) settings"
# HyperX keyboard
elif printf '%s' "$INPUTS" | grep -qi "Kingston HyperX Alloy Origins 60"; then
    OPTIONS="caps:escape,altwin:ctrl_alt_win,lv3:menu_switch"
    MESSAGE="Applied HyperX (ANSI) settings"
fi

run_sway() {
    local cmd="$1"
    local out

    if ! out=$(swaymsg -r "$cmd" 2>&1); then
        echo "$out" >&2
        return 1
    fi

    if printf '%s' "$out" | grep -q '"success":false'; then
        echo "$out" >&2
        return 1
    fi
}

run_sway "input type:keyboard xkb_model $MODEL" || {
    echo "Failed command: input type:keyboard xkb_model $MODEL" >&2
    exit 1
}

run_sway "input type:keyboard xkb_layout $LAYOUT" || {
    echo "Failed command: input type:keyboard xkb_layout $LAYOUT" >&2
    exit 1
}

run_sway "input type:keyboard xkb_variant $VARIANT" || {
    echo "Failed command: input type:keyboard xkb_variant $VARIANT" >&2
    exit 1
}

run_sway "input type:keyboard xkb_options \"$OPTIONS\"" || {
    echo "Failed command: input type:keyboard xkb_options $OPTIONS" >&2
    exit 1
}

echo "$MESSAGE (sway)"
