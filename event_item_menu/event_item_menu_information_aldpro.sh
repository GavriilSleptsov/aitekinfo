#!/bin/bash
#---------------init event for item_menu_information_freeipa-------------------------------
declare -A event_menu
event_menu["$item_menu_information_aldpro"]="run_menu ${items_aldpro_actions[@]}"
event_menu["$item_menu_aldpro_install"]="aldpro_install"
