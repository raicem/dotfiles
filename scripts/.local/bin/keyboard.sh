#!/bin/bash

# Check connected keyboards
xinput list > /tmp/xinput_list.txt


# Apple keyboard "Cem"
if grep -q "Cem" /tmp/xinput_list.txt; then
    setxkbmap -model applealu_ansi -layout tr -variant alt -option -option caps:escape -option ctrl:swap_lwin_lctl -option ctrl:swap_rwin_rctl -option lv3:menu_switch
    echo "Applied Apple (Cem) settings"
# Apple keyboard "Cem"
elif grep -q "Apple" /tmp/xinput_list.txt; then
    setxkbmap -model applealu_ansi -layout tr -variant alt -option -option caps:escape -option ctrl:swap_lwin_lctl -option ctrl:swap_rwin_rctl -option lv3:menu_switch
    echo "Applied Apple (Cem) settings"
# HyperX keyboard
elif grep -q "Kingston HyperX Alloy Origins 60" /tmp/xinput_list.txt; then
    setxkbmap -layout tr -variant alt -option -option caps:escape -option altwin:left_win_alt -option altwin:ctrl_alt_win -option lv3:menu_switch
    echo "Applied HyperX (ANSI) settings"
# Internal keyboard (fallback)
else
    setxkbmap -layout tr -variant alt -option -option caps:escape -option altwin:left_win_alt -option altwin:ctrl_alt_win -option lv3:rctl_switch
    echo "Applied internal (ISO) settings"
fi

rm /tmp/xinput_list.txt
