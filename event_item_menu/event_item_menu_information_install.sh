#!/bin/bash
#---------------init event for item_menu_information_install="Установка программ" menu-------------------------------
declare -A event_menu
event_menu["$item_menu_information_install"]="run_menu ${item_menu_install_apps[@]}"
event_menu["$item_menu_install_kaspersky"]="kaspersky"
event_menu["$item_menu_install_finereader"]="finereader"
event_menu["$item_menu_install_crypto1290"]="crypto1290"
event_menu["$item_menu_install_crypto1145"]="crypto1145"
event_menu["$item_menu_install_pdf_editor"]="install_apps"
event_menu["$item_menu_install_telegram"]="install_apps"
event_menu["$item_menu_install_viber"]="install_apps"
event_menu["$item_menu_install_whatsapp"]="install_apps"
event_menu["$item_menu_install_wps"]="install_apps"
event_menu["$item_menu_install_code"]="install_apps"
event_menu["$item_menu_install_notepadplus"]="install_apps"
event_menu["$item_menu_install_yandex"]="install_app_repo"
event_menu["$item_menu_install_remina"]="install_app_repo"
event_menu["$item_menu_install_xrdp"]="install_app_repo"
event_menu["$item_menu_install_scan"]="install_app_repo"
event_menu["$item_menu_install_seahorse"]="install_app_repo"
event_menu["$item_menu_install_myoffice"]="xdg-open https://coapi-myoffice.aitekinfo.ru/api/v1/public/a0eb7bb7-d4ef-4450-a0ef-f54ab1642aae/107585007/content?download=true &"


