#!/bin/bash
##########----------"Файл конфигурации"----------##########

source /opt/aitekinfo/aitekinfo_conf.sh

####################################################################################
############################## НАЧАЛО БЛОКА item_menu ##############################
####################################################################################

##########----------"Главное меню"----------##########
source $path_items/items_main_menu.sh

##########----------"Информационные ресурсы"----------##########
source $path_items/item_menu_information_resources.sh

##########----------"Инструкции"----------##########
source $path_items/item_menu_information_instructions.sh

##########----------"Что делать, если не работает?"----------##########
source $path_items/item_menu_information_help.sh

##########----------"Установка программ"----------##########
source $path_items/item_menu_information_install.sh

##########----------"Удаление программ"----------##########
source $path_items/item_menu_remove_apps.sh

##########----------"Добавить сетевые репозитори"----------##########
source $path_items/item_menu_information_repo.sh

##########----------"Драйвера для принтеров"----------##########
source $path_items/item_menu_information_printers.sh

#---------------init for item_menu_firma_samsung_models menu-------------------------------
item_driver_Samsung_ML_2851ND="Samsung-ML-2851ND"
item_menu_govno_printer="printer"
item_menu_firma_Samsung_models=("\"$item_driver_Samsung_ML_2851ND\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$exit_menu\"" "\"$exit_app\"")

##########----------"Модель принтера Kyocera"----------##########
source $path_items/item_menu_firma_Kyocera_models.sh

##########----------"Обновление и новвоведения"----------##########
source $path_items/item_menu_information_pomogator.sh

##########----------"Действия с Freeipa"----------##########
source $path_items/item_menu_information_freeipa.sh

##########----------"Действия с AldPro"----------##########
source $path_items/item_menu_information_aldpro.sh

####################################################################################
############################## КОНЕЦ БЛОКА item_menu ###############################
####################################################################################

declare -A event_menu
event_menu["$exit_app"]="exit 1"

###########################################################################################
############################## НАЧАЛО БЛОКА event_item_menu ###############################
###########################################################################################

##########----------"Информационные ресурсы"----------##########
source $path_events/event_item_menu_information_resources.sh

##########----------"Инструкции"----------##########
source $path_events/event_item_menu_information_instruction.sh

##########----------"Что делать, если не работает?"----------##########
event_menu["$item_menu_information_help"]="run_menu ${item_menu_help_all[@]}"
event_menu["$item_menu_help_papki"]="info_shared_papki"
event_menu["$item_menu_help_printer"]="info_install_printer"

##########----------"Установка программ"----------##########
source $path_events/event_item_menu_information_install.sh

##########----------"Удаление программ"----------##########
source $path_events/event_item_menu_information_remove.sh

##########----------"Добавить сетевые репозитории"----------##########
source $path_events/event_item_menu_information_repo.sh

##########----------"Драйвера для принтеров"----------##########
event_menu["$item_menu_information_printers"]="run_menu ${item_menu_firmi_printers[@]}"

##########----------"Фирмы принтеров"----------##########
event_menu["$item_menu_firma_Samsung"]="run_menu ${item_menu_firma_Samsung_models[@]}"
event_menu["$item_menu_firma_Kyocera"]="run_menu ${item_menu_firma_Kyocera_models[@]}"

#-------------init menu event for item_menu_firma_Samsung_models Фирма=Самсунг-----------------------
event_menu["$item_driver_Samsung_ML_2851ND"]="get_drivers"

#-------------init menu event for item_menu_firma_Kyocera_models Фирма=Киосера-----------------------
source $path_events/event_item_menu_firma_Kyocera_models.sh

##########----------"Действия с FreeIpa"----------##########
source $path_events/event_item_menu_information_freeipa.sh

##########----------"Драйвера для принтеров"----------##########
source $path_events/event_item_menu_information_pomogator.sh

##########----------"Действия с AldPro"----------##########
source $path_events/event_item_menu_information_aldpro.sh

source $path_install_functions/install_telegram.sh

source $path_install_functions/install_master-pdf-editor.sh

source $path_install_functions/install_remmina.sh

source $path_install_functions/install_myoffice.sh

source $path_install_functions/install_crypto1290.sh

source $path_install_functions/install_finereader.sh

source $path_install_functions/install_whatsapp.sh

source $path_install_functions/install_wps.sh

source $path_install_functions/install_notepad.sh

source $path_install_functions/install_yandex.sh

source $path_install_functions/install_armgs.sh
###########################################################################################
############################## КОНЕЦ БЛОКА event_item_menu ################################
###########################################################################################


info_install_printer(){
    $(zenity --info --text="Чтобы добавить принтер необходимо перейти от имени пользователя, которому добавляем принтер:\n Пуск -> Панель управления -> Оборудование -> Принтеры -> Нажать правой кнопкой мышки на принтер -> добавить принтер и ищем нужный принтер.\n Скачать необходимые драйвера можно во вкладке 'Драйвера для принтера' в данном приложение." --height=250 --width=350)
}

info_shared_papki() {
    $(zenity --info --text="$papki" --height=200 --width=300)
}

#######################################################
##########----------"Check функции"----------##########
#######################################################
check_head_shared(){
    check_head=$(grep "Archives" "/home/$USER/.config/rusbitech/fly-fm-vfs.conf")
        if [[ "$check_head" == "" ]]; then
            echo "[Archives]
            Extensions=.zip,.rar~,.7z,.tar,.tgz,.tar.gz,.tar.bz2,.tar.xz,.iso~
            [General]
            AutoDetectBadPaths=true" > /home/$USER/.config/rusbitech/fly-fm-vfs.conf
        fi
}

check_cancel(){
	if [[ $? -eq 1 ]]; then
    run_menu "${items_main_menu[@]}"
    fi
}

echo_check () {
	echo $selected_item_menu >> /tmp/check.txt
}

#######################################################
##########----------"Функции"----------################
#######################################################

get_drivers() {
    mod_selected_item_menu=$(echo "$selected_item_menu" | sed 's/ /+/g')
    wget -O /home/$USER/Desktop/"$selected_item_menu".PPD https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=printer%2F"$mod_selected_item_menu".PPD

}

remove_app(){
    local passwd=$(zenity --password)
    check_cancel
    echo $passwd | sudo -S apt remove "$1" -y
}

#-------------------------------------domain menu------------------------------------#
freeipa(){
    $(zenity --info --text="Перед продолжением необходимо в dns указать первым, dns адрес вашего контроллера домена" --height=300 --width=400)
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета astra-freeipa-client" --text="Подождите, идет установка..." --height=300 --width=400 --auto-close &
    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install astra-freeipa-client -y
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
    form_data=$(zenity --forms --title="Введите данные" --text="Введите данные:" \
    --add-entry="Введите ваш домен FreeIpa типа: astra.domain" \
    --add-entry="Введите логин администратора домена astra.domain" \
    --add-password="Пароль для админа домена" )
    # Разбиение строки с данными на отдельные переменные
    domain_freeipa=$(echo "$form_data" | awk -F '|' '{print $1}')
    user_freeipa=$(echo "$form_data" | awk -F '|' '{print $2}')
    pass_freeipa=$(echo "$form_data" | awk -F '|' '{print $3}')
    check_cancel
    echo $passwd | sudo -S astra-freeipa-client -d "$domain_freeipa" -u "$user_freeipa" -p "$pass_freeipa" -y --par "--force --enable-dns-updates"
    echo $passwd | sudo -S sed -i 's/dns_lookup_realm = false/dns_lookup_realm = true/g'  /etc/krb5.conf
    echo $passwd | sudo -S sed -i 's/dns_lookup_kdc = false/dns_lookup_kdc = true/g'  /etc/krb5.conf
    # запоминать последний удачный вход в систему
    echo $passwd | sudo -S sed -i 's/PreselectUser=None/PreselectUser=Previous/g'  /etc/X11/fly-dm/fly-dmrc
    # убрать выбор доменов доверительных отношений, но воможность через user@domain останется
    # echo $passwd | sudo -S chmod -x /etc/domains.list.d/astra-freeipa-domains-ctl
}

aldpro_install() {
	fly-term -e "sudo /opt/aitekinfo/install_functions/install_aldpro.sh"
}


##########----------"Сетевые репозитории РЦИТ"----------##########
repo_rcit(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")
    check_cancel    
	echo $passwd | sudo -S bash -c "echo -e '#---------- Сетевые репозитории РЦИТ ----------' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-main/     1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-update/   1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-base/     1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-extended/ 1.7_x86-64 astra-ce' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/repo/repository-main/     1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
	echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://10.50.1.53/astraad ./' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозитории РЦИТ успешно добавлены. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_stable1_7(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")
    check_cancel    
	echo $passwd | sudo -S bash -c "echo -e '#---------- Репозитории stable 1.7 ----------' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/        1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/        1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/      1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/    1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/uu/last/repository-base 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозитории stable 1.7 успешно добавлены. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_frozen1_7_3(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")    
    check_cancel
	echo $passwd | sudo -S bash -c "echo -e '#---------- Репозитории frozen 1.7.3 ----------' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/          1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/      1.7_x86-64 main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-base/     1.7_x86-64 main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозитории frozen 1.7.3 успешно добавлены. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_info(){
    $(zenity --info --text=" Описание веток репозиториев
 \n✔️ Основной репозиторий (main) - сертифициронный установочный диск
 \n✔️ Оперативные обновления (update) - обновления для main репозитория 
 \n✔️ Базовый репозиторий (base) - включает в себя репозиторий main , update и компаненты разработчика (dev) с обновлениями (dev-update)
 \n✔️ Расширенный репозиторий (extended) - Дополнительное ПО" --height=500 --width=500)
}
#-------------------------------------pomogator settings function------------------------------------#
pomogator_update(){
    check_cancel
    if dpkg -s git  &>/dev/null; then
    passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
        zenity --progress --pulsate --title="Обновление программы" --text="Подождите, идет установка..." --auto-close &
        (
        tmp_folder=$(mktemp -d)
        echo $passwd | sudo -S git clone --depth=1 "https://github.com/GavriilSleptsov/aitekinfo.git" "$tmp_folder"
        exit_code=$?
        # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            $(zenity --info --title="Успех" --text="Программа успешно обновлена! Для запуска обновленной версии откройте приложение повторно!" --height=150 --width=300)
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке обнавления."
        fi
        FOLDER_PATH=/opt/aitekinfo/
        # Замените файлы в целевой папке
        echo $passwd | sudo -S cp -R "$tmp_folder"/* "$FOLDER_PATH"

        # Удалите временную папку с репозиторием
        echo $passwd | sudo -S rm -rf "$tmp_folder"
        ) | zenity --progress --pulsate --auto-close
            $(zenity --question --text "Перезапустите прорамму, для применения обновления, сделать это сейчас?" --ok-label="Закрыть" --cancel-label="Отмена" --height=250 --width=200)
            if [[ $? -eq 0 ]]; then
                exit 0
				
            fi
    else
        $(zenity --info --text=" У вас не установлена утилита git" --height=150 --width=300)
        $(zenity --question --text "Хотите установить программу git?" --ok-label="Установить" --cancel-label="Отмена" --height=150 --width=300)
        if [[ $? -eq 0 ]]; then
        passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
        echo "$passwd" | sudo -Sv >/dev/null 2>&1
            if [ $? -eq 0 ]; then
            echo $passwd | sudo -S apt install git -y
            else
            $(zenity --info --text "Неверный пароль администратора! Или у вас не хватает прав!" --height=150 --width=300)
            fi
        else
            exit 0
        fi
    fi

}

pomogator_news(){
    news=$(curl "https://raw.githubusercontent.com/GavriilSleptsov/aitekinfo/main/news")
    $(zenity --info --text="$news" --height=350 --width=500)

}

pomogator_version(){
    version=$(curl "https://raw.githubusercontent.com/GavriilSleptsov/aitekinfo/main/version.sh")
    trimmed_version=$(echo "$version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
    if [[ $version == *html* ]]; then
    $(zenity --info --text=" У вас нет доступа к репозиторию для обновления" --height=150 --width=300)
    else
        if [[ "$trimmed_version" != "$version_now" ]]; then
            $(zenity --info --text="Вышло обновление "$trimmed_version".\nСпасибо что используете наши технологии" --height=150 --width=300)
            $(zenity --question --text="Хотите посмотреть новвоведения?" --ok-label="Да" --cancel-label="Нет" --height=150 --width=300)
                if [[ $? -eq 0 ]]; then
                newss=$(curl "https://raw.githubusercontent.com/GavriilSleptsov/aitekinfo/main/news")
                $(zenity --info --text="$newss" --height=400 --width=700)
                fi
            else
                $(zenity --info --text="У вас установленно актуальное обновление "$version_now".\nСпасибо что используете наши технологии" --height=150 --width=300)
            fi
        fi
}

#-------------------------------------main function------------------------------------#
check_update(){
     if dpkg -s git  &>/dev/null; then
        if dpkg -s curl  &>/dev/null; then
            version=$(curl "https://raw.githubusercontent.com/GavriilSleptsov/aitekinfo/main/version.sh")
            trimmed_version=$(echo "$version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
                if [[ $version == *html* ]]; then
                $(zenity --info --text=" У вас нет доступа к репозиторию для обновления" --height=150 --width=300)
                else
                    if [[ "$trimmed_version" != "$version_now" ]]; then
                        $(zenity --info --text="Вышло обновление приложения "$trimmed_version".\nСпасибо что используете наши технологии" --height=150 --width=300)
                        $(zenity --question --text="Хотите посмотреть новвоведения?" --ok-label="Да" --cancel-label="Нет" --height=150 --width=300)
                        if [[ $? -eq 0 ]]; then
                            newss=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=news&inline=false")
                            $(zenity --question  --title="Новости и обновления?" --text="$newss.\nХотите обновить приложение?" --ok-label="Обновить" --cancel-label="Не обновлять" --height=400 --width=700)
                            if [[ $? -eq 0 ]]; then
                            pomogator_update
                            fi
                        fi
                        else
                            $(zenity --info --text="У вас установлено актуальное обновление "$version_now".\nСпасибо что используете наши технологии" --height=150 --width=300)
                        fi
                    fi
    else
        $(zenity --info --text=" У вас не установлена утилита curl" --height=150 --width=300)
        $(zenity --question --text "Хотите установить программу curl?" --ok-label="Установить" --cancel-label="Отмена" --height=150 --width=300)
        if [[ $? -eq 0 ]]; then
        passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
            echo "$passwd" | sudo -Sv >/dev/null 2>&1
            if [ $? -eq 0 ]; then
            zenity --progress --pulsate --title="Обновление программы" --text="Подождите, идет установка..." --auto-close &
            (
            echo $passwd | sudo -S apt install curl -y
            exit_code=$?
            # Проверка кода завершения и отображение соответствующего сообщения
                if [ $exit_code -eq 0 ]; then
                    zenity --info --title="Успех" --text="Программа успешно обнавлена!"
                else
                    zenity --error --title="Ошибка" --text="Ошибка при установке обнавления."
                fi
            ) | zenity --progress --pulsate --auto-close
            else
            $(zenity --info --text "Неверный пароль администратора! Или у вас не хватает прав!" --height=150 --width=300)
            fi
        else
            exit 0
        fi
    fi
    else
    $(zenity --info --text=" У вас не установлена утилита git" --height=150 --width=300)
    $(zenity --question --text "Хотите установить программу git?" --ok-label="Установить" --cancel-label="Отмена" --height=150 --width=300)
        if [[ $? -eq 0 ]]; then
        passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
            echo "$passwd" | sudo -Sv >/dev/null 2>&1
            if [ $? -eq 0 ]; then
            zenity --progress --pulsate --title="Обновление программы" --text="Подождите, идет установка..." --auto-close &
            (
            echo $passwd | sudo -S apt install git -y
             exit_code=$?
            # Проверка кода завершения и отображение соответствующего сообщения
            if [ $exit_code -eq 0 ]; then
                zenity --info --title="Успех" --text="Программа успешно обнавлена!"
            else
                zenity --error --title="Ошибка" --text="Ошибка при установке обнавления."
            fi
            ) | zenity --progress --pulsate --auto-close
            else
            $(zenity --info --text "Неверный пароль администратора! Или у вас не хватает прав!" --height=150 --width=300)
            fi
        else
            exit 0
        fi
    fi
     
}

run_event() {    
    local command_to_run="$1"
    eval "$command_to_run"
}

rend_menu() {
    local choices=("$@")  
    selected_item_menu=$(zenity --list --title="Меню выбора" --column="Выберите" "${choices[@]}"  --height=600 --width=600)
}

run_menu(){
     local menu_items=("$@") 
    
     while true; do
        rend_menu "${menu_items[@]}"
        if [ $? -eq 0 ]; then
            if [ -n "${event_menu["$selected_item_menu"]}" ]; then 
            run_event "${event_menu["$selected_item_menu"]}"
            elif  [ "$selected_item_menu" == "$exit_menu" ]; then
                selected_item_menu=""
                return        
            fi
        else
            exit 1
        fi
     done
}

run_app() {
    $(zenity --info --text="$app_info" --height=150 --width=250)
    check_update
    run_menu "${items_main_menu[@]}"
}

#--------------------Запуск программы---------------------------
run_app
