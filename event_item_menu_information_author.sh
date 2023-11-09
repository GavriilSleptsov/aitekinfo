#!/bin/bash
#---------------init menu event for item_menu_information_author="Связь с автором и пожелания" menu-------------------------------
mail_author(){
    $(zenity --info --text="Для связи с автором приложения напишите на почту gabidullina.a@sseu.ru.\nВ теме письма укажите ПОМОГАТОР.\nДругие интересные проекты https://gitflic.ru/user/gabidullin-aleks\nХорошего настроения и продуктивной работы!" --height=150 --width=300)
}

declare -A event_menu
event_menu["$item_menu_information_author"]="run_menu ${item_menu_author[@]}"
event_menu["$item_menu_author_mail"]="mail_author"
