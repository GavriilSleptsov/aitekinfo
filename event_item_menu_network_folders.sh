#!/bin/bash
#---------------init event for item_menu_network_folders="Сетевые папки" menu-------------------------------
declare -A event_menu
event_menu["$item_menu_network_folders"]="run_menu ${items_share_menu[@]}"
event_menu["$item_menu_share_folder"]="filecore"
event_menu["$item_menu_share_hands"]="share_folder"
event_menu["$item_menu_share_remove"]="remove_share_folder"