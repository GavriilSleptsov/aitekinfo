#!/bin/bash
#---------------init event for item_menu_information_do-------------------------------
event_menu["$item_menu_information_do"]="run_menu ${item_menu_information_do_all[@]}"
event_menu["$item_menu_information_do_print"]="print"
event_menu["$item_menu_information_do_link"]="link"
event_menu["$item_menu_information_do_sudo"]="sudo_open"
event_menu["$item_menu_information_do_share"]="share"
