#!/bin/bash
#-------------init event for item_menu_information_pomogator="Обновление и нововведения"-----------------------
declare -A event_menu
event_menu["$item_menu_information_pomogator"]="run_menu ${item_menu_pomogator_all[@]}"
event_menu["$item_menu_information_pomogator_version"]="pomogator_version"
event_menu["$item_menu_information_pomogator_update"]="pomogator_update"
event_menu["$item_menu_information_pomogator_news"]="pomogator_news"
