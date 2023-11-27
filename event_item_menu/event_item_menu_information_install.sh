#!/bin/bash
#---------------init event for item_menu_information_install="Установка программ" menu-------------------------------
declare -A event_menu
event_menu["$item_menu_information_install"]="run_menu ${item_menu_install_apps[@]}"
event_menu["$item_menu_install_finereader"]="install_app_finereader"
event_menu["$item_menu_install_crypto1290"]="install_app_crypto1290"
event_menu["$item_menu_install_pdf_editor"]="install_app_master-pdf-editor"
event_menu["$item_menu_install_telegram"]="install_app_telegram"
event_menu["$item_menu_install_whatsapp"]="install_app_whatsapp"
event_menu["$item_menu_install_wps"]="install_app_wps"
event_menu["$item_menu_install_notepadplus"]="install_app_notepad"
event_menu["$item_menu_install_yandex"]="install_app_yandex"
event_menu["$item_menu_install_remina"]="install_app_remmina"
event_menu["$item_menu_install_myoffice"]="install_app_myoffice"
event_menu["$item_menu_install_armgs"]="install_app_armgs"

