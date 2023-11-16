#!/bin/bash
#-------------init event for item_menu_information_instructions="Инструкции СГЭУ"-----------------------
declare -A event_menu
event_menu["$item_menu_information_instructions"]="run_menu ${item_menu_instructions_all[@]}"
event_menu["$item_menu_instruction_google"]="firefox -new-tab site &"
