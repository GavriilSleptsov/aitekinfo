#!/bin/bash
#---------------init event for item_menu_information_freeipa-------------------------------
declare -A event_menu
event_menu["$item_menu_information_freeipa"]="run_menu ${items_freeipa_actions[@]}"
event_menu["$item_menu_freeipa_connect"]="freeipa"