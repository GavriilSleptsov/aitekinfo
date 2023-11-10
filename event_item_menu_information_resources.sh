#!/bin/bas
declare -A event_menu
event_menu["$item_menu_information_resources"]="run_menu ${items_resources[@]}"
event_menu["$item_menu_astra"]="firefox -new-tab https://astralinux.ru/ &"
