#!/bin/bas
declare -A event_menu
event_menu["$item_menu_information_resources"]="run_menu ${items_resources[@]}"
event_menu["$item_menu_astra"]="xdg-open https://astralinux.ru/ &"
event_menu["$item_menu_aitekinfo_site"]="xdg-open https://aitekinfo.ru/ &"
event_menu["$item_menu_instruction_myoffice_text"]="xdg-open https://support.myoffice.ru/help/text/desktop/ &"

