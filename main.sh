#!/bin/bash
#---------------init core config-------------------------------------

path=/opt/aitekinfo
source $path/version.sh
exit_app="Выход"
exit_menu="Назад"
selected_item_menu=""
app_info="Программа помощник: Помогатор\nВерсия: "$version_now"\nРазработчик: Габидуллин А.\nВкладки установка удаление программ могут быть использованны только под локальным или доменным администратором\n © 2023"
crypto="Для работы с сайтами использующими ЭЦП для подтверждения входа необходимо устанвить яндекс браузер!" 
papki="1.Необходимо перезайти в сессию.\n2. Перезагрузить ПК.\n3. Зайти в учетную запись имяпользователя@domain.name и пароль от windows прошлый ( если пароль устарел сменить его на новый)"
#---------------init items_main_menu-------------------------------
source $path/items_main_menu.sh

#---------------init for item_menu_information_resources_of="Информационные ресурсы СГЭУ"-------------------------------
source $path/item_menu_information_resources.sh

#---------------init item_menu_information_instructions="Инструкции "-------------------------------
source $path/item_menu_information_instructions.sh

#---------------item_menu_information_help="Что делать, если не работает?"-------------------------------
source $path/item_menu_information_help.sh

#---------------init for item_menu_information_install="Установка программ" menu-------------------------------
source $path/item_menu_information_install.sh

#---------------init for item_menu_information_remove="Удаление программ" menu-------------------------------
source $path/item_menu_remove_apps.sh

#---------------init for item_menu_information_repo="Добавить сетевые репозитории" menu-------------------------------
source $path/item_menu_information_repo.sh

#---------------init for item_menu_information_printers="Драйвера для принтеров" menu-------------------------------
source $path/item_menu_information_printers.sh

#---------------init for item_menu_firma_samsung_models menu-------------------------------
item_driver_Samsung_ML_2851ND="Samsung-ML-2851ND"
item_menu_govno_printer="printer"
item_menu_firma_Samsung_models=("\"$item_driver_Samsung_ML_2851ND\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$item_menu_govno_printer\"" "\"$exit_menu\"" "\"$exit_app\"")

#---------------init for item_menu_firma_Kyocera_models menu-------------------------------
source $path/item_menu_firma_Kyocera_models.sh

#---------------init for item_menu_information_pomogator="Обновление и нововведения" menu-------------------------------
source $path/item_menu_information_pomogator.sh

#-------------init menu event-----------------------
declare -A event_menu
event_menu["$exit_app"]="exit 1"

#-------------init event for item_menu_information_resources="Информационные ресурсы СГЭУ"-----------------------
source $path/event_item_menu_information_resources.sh

#-------------init event for item_menu_information_instructions="Инструкции СГЭУ"-----------------------
source $path/event_item_menu_information_instruction.sh

#---------------init event for item_menu_information_help="Что делать, если не работает?"-------------------------------
event_menu["$item_menu_information_help"]="run_menu ${item_menu_help_all[@]}"
event_menu["$item_menu_help_papki"]="info_shared_papki"
event_menu["$item_menu_help_printer"]="info_install_printer"

#---------------init event for item_menu_information_install="Установка программ" menu-------------------------------
source $path/event_item_menu_information_install.sh

#---------------init event for item_menu_information_remove="Удаление программ" menu-------------------------------
source $path/event_item_menu_information_remove.sh

#---------------init event for item_menu_information_repo="Добавить сетевые репозитории" menu-------------------------------
source $path/event_item_menu_information_repo.sh

#---------------init for item_menu_information_printers="Драйвера для принтеров" menu-------------------------------
event_menu["$item_menu_information_printers"]="run_menu ${item_menu_firmi_printers[@]}"

#-------------init menu event for item_menu_firmi_printers Фирмы принтеров-----------------------
event_menu["$item_menu_firma_Samsung"]="run_menu ${item_menu_firma_Samsung_models[@]}"
event_menu["$item_menu_firma_Kyocera"]="run_menu ${item_menu_firma_Kyocera_models[@]}"

#-------------init menu event for item_menu_firma_Samsung_models Фирма=Самсунг-----------------------
event_menu["$item_driver_Samsung_ML_2851ND"]="get_drivers"

#-------------init menu event for item_menu_firma_Kyocera_models Фирма=Киосера-----------------------
source $path/event_item_menu_firma_Kyocera_models.sh

#---------------init event for item_menu_information_freeipa="Домен" menu-------------------------------
source $path/event_item_menu_information_freeipa.sh

#---------------init event for item_menu_information_update Обновление системы-------------------------------
event_menu["$item_menu_information_update"]="system_update"

#---------------init event for item_menu_information_pomogator обновление помогатора-------------------------------
source $path/event_item_menu_information_pomogator.sh

#---------------init menu event for item_menu_information_help="Что делать, если не работает?" menu------------------
info_install_printer(){
    $(zenity --info --text="Чтобы добавить принтер необходимо перейти от имени пользователя, которому добавляем принтер:\n Пуск -> Панель управления -> Оборудование -> Принтеры -> Нажать правой кнопкой мышки на принтер -> добавить принтер и ищем нужный принтер.\n Скачать необходимые драйвера можно во вкладке 'Драйвера для принтера' в данном приложение." --height=250 --width=350)
}

info_shared_papki() {
    $(zenity --info --text="$papki" --height=200 --width=300)
}

#-------------------------------------check function------------------------------------#

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

#-------------------------------------all function------------------------------------#

get_drivers() {
    mod_selected_item_menu=$(echo "$selected_item_menu" | sed 's/ /+/g')
    wget -O /home/$USER/Desktop/"$selected_item_menu".PPD https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=printer%2F"$mod_selected_item_menu".PPD

}

install_apps() {
    passwd=$(zenity --password)
    check_cancel
    wget http://easyastra.ru/store/"$selected_item_menu".deb -P /home/$USER/Desktop/
    file="/home/$USER/Desktop/"$selected_item_menu".deb"
    # Установка пакета с указанием прогресса
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install -f "$file" -y
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
    rm /home/$USER/Desktop/"$selected_item_menu".deb
}

install_app_repo() {
    passwd=$(zenity --password)
    check_cancel
    # Установка пакета с указанием прогресса
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install "$selected_item_menu" -y
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
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

aldpro(){
    app_info="Программа подключения клиента к домену ALDpro. \nАвтор данной программы Габидуллин Александр  © 2023. \nДля связи с автором по этой или другой программе писать на почту gabidullin.aleks@yandex.ru. \nТакже есть youtube-канал с более подробной инструкцией @XizhinaAdministratora"
    internet_error="У вас проблемы с доступом к сайту dl.astralinux.ru. Проверьте настройку интернет соединения и правильность dns."
    license="Продолжая установку ALDPro с помощью данной программы, Вы подтверждаете что приобрели лицензию и согласны с ее условиями. Автор программы не предоставляет лицензию на продукт."
    reboot="Для корректной работы необходимо перезагрузить компьютер."
    if ping -c 1 dl.astralinux.ru &> /dev/null; then
        zenity --info --text="$app_info" --height=200 --width=200
        zenity --info --text="$license" --height=200 --width=200
        if id -nG | grep -qw "astra-admin"; then
            echo ok
        else
            zenity --info --text="Пользователь не принадлежит группе astra-admin. Необходимо зайди под пользователем с правами администратора."
            exit 1
        fi
        passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
        echo "$passwd" | sudo -Sv >/dev/null 2>&1
            if [ $? -eq 0 ]; then
            echo ok
            else
                zenity --info --text="Неправильный пароль от sudo. Необходимо запустить скрипт повторно."
                exit 1
                # Добавьте здесь код, который должен выполниться, если пароль от sudo введен неправильно.
            fi
            form_data=$(zenity --forms --title="Введите данные" --text="Введите данные:" \
                --add-entry="Введите имя клиента домена типа: client1" \
                --add-entry="Введите имя домена типа: domain.test" \
                --add-entry="Введите имя полное доменное имя клиента типа: client1.domain.test" \
                --add-entry="Введите ip адрес вышего контроллера домена ALDPro: 10.10.10.10" \
                --add-entry="Введите логин администратора домена ALDPro типа: admin" \
                --add-password="Введите пароль администратора домена $admin ALDPro: Password123" )
                # Разбиение строки с данными на отдельные переменные
                small_fqdn=$(echo "$form_data" | awk -F '|' '{print $1}')
                big_fqdn=$(echo "$form_data" | awk -F '|' '{print $2}')
                fqdn=$(echo "$form_data" | awk -F '|' '{print $3}')
                dns=$(echo "$form_data" | awk -F '|' '{print $4}')
                admin=$(echo "$form_data" | awk -F '|' '{print $5}')
                pass_domain=$(echo "$form_data" | awk -F '|' '{print $6}')
                version_astra=$(cat /etc/astra_version)
                version="1.7.4"
                version_old="У вас установлена версия астры  "$version_astra" и она будет обновлена до 1.7.4"
                version_new="У вас установлена версия астры  "$version_astra" и установка продолжиться дальше"
                    if [ $version_astra != "$version" ]; then
                        zenity --info --text="$version_old" --height=300 --width=400
                    else
                        zenity --info --text="$version_new" --height=300 --width=400
                    fi
                (
                #репы
                echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/aldpro/stable/repository-extended/ generic main' > /etc/apt/sources.list.d/aldpro.list"
                echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/aldpro/stable/repository-main/ 2.1.0 main' >> /etc/apt/sources.list.d/aldpro.list"
                echo $passwd | sudo -S bash -c "echo -e 'deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-extended 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
                echo $passwd | sudo -S bash -c "echo -e 'deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-base 1.7_x86-64 main non-free contrib' >> /etc/apt/sources.list"
                # установка сертификатов
                echo $passwd | sudo -S apt update
                echo $passwd | sudo -S apt install ca-certificates -y
                #переименовываем тачку в домен
                echo $passwd | sudo -S hostnamectl set-hostname $fqdn
                #меняет файл hosts
                echo $passwd | sudo -S sed -i '/^127\.0\.0\.1/d' /etc/hosts 
                echo $passwd | sudo -S sed -i '/^127\.0\.1\.1/d' /etc/hosts
                echo $passwd | sudo -S bash -c "echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts"
    #echo $passwd | sudo -S bash -c "echo '$ipaddres $fqdn $small_fqdn' >> /etc/hosts"
                echo $passwd | sudo -S bash -c "echo '127.0.1.1 $small_fqdn' >> /etc/hosts"
                #Добавляем приоритет
                echo $passwd | sudo -S bash -c "echo 'Package: *' >> /etc/apt/preferences.d/aldpro"
                echo $passwd | sudo -S bash -c 'echo Pin: release n=generic >> /etc/apt/preferences.d/aldpro'
                echo $passwd | sudo -S bash -c 'echo Pin-Priority: 900 >> /etc/apt/preferences.d/aldpro'
                # обновление системы
                echo $passwd | sudo -S apt update
                echo $passwd | sudo -S apt install astra-update -y
                echo $passwd | sudo -S astra-update -A -r -T
                echo $passwd | sudo -S DEBIAN_FRONTEND=noninteractive apt-get install -q -y aldpro-client
                exit_code=$?
                # Проверка кода завершения и отображение соответствующего сообщения
                    if [ $exit_code -eq 0 ]; then
                        zenity --info --title="Успех" --text="Система успешно обновлена"
                    else
                        zenity --error --title="Ошибка" --text="Ошибка при обновление системы."
                        exit 1
                    fi
                ) | zenity --progress --pulsate
                #меняем resolf.conf
                (
                echo $passwd | sudo -S bash -c "echo '# Generated by NetworkManager' > /etc/resolv.conf"
                echo $passwd | sudo -S bash -c "echo 'search $big_fqdn' >> /etc/resolv.conf"
                echo $passwd | sudo -S bash -c "echo 'nameserver $dns' >> /etc/resolv.conf"
                echo $passwd | sudo -S /opt/rbta/aldpro/client/bin/aldpro-client-installer -c "$big_fqdn" -u "$admin" -p "$pass_domain" -d "$small_fqdn" -i -f
                exit_code=$?
                # Проверка кода завершения и отображение соответствующего сообщения
                    if [ $exit_code -eq 0 ]; then
                        zenity --info --title="Успех" --text="Клиент успешно подключен"
                    else
                        zenity --error --title="Ошибка" --text="Ошибка при подключению к домену"
                        exit 1
                    fi
                ) | zenity --progress --pulsate
                zenity --info --text="$reboot" --height=200 --width=200
    else
        zenity --info --text="$internet_error" --height=300 --width=400
    fi
}

#-------------------------------------soft function------------------------------------#
anaconda(){
    passwd=$(zenity --password)
    check_cancel
    # Установка пакета с указанием прогресса
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S wget --no-check-certificate https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh  -P /opt/
    echo $passwd | sudo -S chmod +x /opt/Anaconda3-2023.07-1-Linux-x86_64.sh
    $(zenity --info --text="ПОСЛЕ УСТАНОВКИ НЕОБХОДИМО ПЕРЕЗАГРУЗИТЬ ПК.Сейчас откроется меню установки в консоли. Нажимаем enter, когда увидите сообщение о лицензионном соглашение нажимаем q, видим внизу окошко вводим yes - жмем enter - yes" --height=300 --width=400)
    echo $passwd | sudo -S fly-term -e "/opt/Anaconda3-2023.07-1-Linux-x86_64.sh -p /opt/anaconda3/"
    echo $passwd | sudo -S chmod -R 777 /opt/anaconda3
    echo $passwd | sudo -S rm /opt/Anaconda3-2023.07-1-Linux-x86_64.sh
    filename="/etc/profile"
    echo $passwd | sudo -S sed -i 's@PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"@PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/anaconda3/bin"@' ${filename}
    echo $passwd | sudo -S sed -i 's@PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"@PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/anaconda3/bin"@' ${filename}
    echo $passwd | sudo -S wget -O /usr/share/applications/flydesktop/anaconda3.desktop https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Fanaconda3.desktop
    echo $passwd | sudo -S wget -O /usr/share/pixmaps/anaconda3.png https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Fanaconda3.png

    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
    rm /home/$USER/Desktop/"$selected_item_menu".deb
}

xampp(){
    $(zenity --info --text="ПОСЛЕ УСТАНОВКИ НЕОБХОДИМО ПЕРЕЗАГРУЗИТЬ ПК"  --height=300 --width=400)
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S wget https://deac-fra.dl.sourceforge.net/project/xampp/XAMPP%20Linux/8.2.4/xampp-linux-x64-8.2.4-0-installer.run -P /opt/
    echo $passwd | sudo -S chmod 755 /opt/xampp-linux-x64-8.2.4-0-installer.run
    echo $passwd | sudo -S /opt/xampp-linux-x64-8.2.4-0-installer.run
    echo $passwd | sudo -S rm /opt/xampp-linux-x64-8.2.4-0-installer.run
    echo $passwd | sudo -S wget -O /usr/share/pixmaps/xampp.png https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Fxampp.png  
    echo $passwd | sudo -S wget -O /usr/share/applications/flydesktop/xampp.desktop https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Fxampp.desktop
    echo $passwd | sudo -S wget -O /opt/xampp.sh https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Fxampp.sh
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
}

workbench(){
    $(zenity --info --text="ПОСЛЕ УСТАНОВКИ НЕОБХОДИМО ПЕРЕЗАГРУЗИТЬ ПК"  --height=300 --width=400)
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/debian.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=repo%2Fdebian.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/debian.deb
    echo $passwd | sudo -S wget -O /etc/apt/sources.list.d/debian.list https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=repo%2Fdebian.list
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/debian.deb
    echo $passwd | sudo -S apt update
    echo $passwd | sudo -S apt install snapd -y
    echo $passwd | sudo -S apt install snap -y
    echo $passwd | sudo -S snap install core
    echo $passwd | sudo -S snap install mysql-workbench-community --devmode    
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
}

crypto1145(){
    if ! dpkg -s yandex-browser-stable &>/dev/null; then
    $(zenity --info --text="$crypto" --height=300 --width=400)
    else
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета astra-freeipa-client" --text="Подождите, идет установка..." --height=300 --width=400 --auto-close &
    (
    wget -O /home/$USER/Desktop/crypto1145.tgz https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2Fcrypto1145.tgz
    tar -zxf /home/$USER/Desktop/crypto1145.tgz -C /home/$USER/Desktop/
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S fly-term -e "/home/$USER/Desktop/linux-amd64_deb/install_gui.sh"
    echo $passwd | sudo -S rm /home/$USER/Desktop/crypto1145.tgz
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/linux-amd64_deb
    echo $passwd | sudo -S apt install pcscd -y 
    wget -O /home/$USER/Загрузки/cades-linux-amd64.tar.gz https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2Fcades-linux-amd64.tar.gz
    wget -O /home/$USER/Загрузки/IFCPlugin-x86_64.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2FIFCPlugin-x86_64.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S rm /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S ln -s /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
    echo $passwd | sudo -S ln -s /opt/cprocsp/lib/amd64/libcppkcs11.so.4.0.4 /usr/lib/mozilla/plugins/lib/libcppkcs11.so
    wget https://www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg -P /home/$USER/Desktop/
    echo $passwd | sudo -S rm /etc/ifc.cfg
    echo $passwd | sudo -S cp /home/$USER/Desktop/ifcx64.cfg /etc/ifc.cfg
    echo $passwd | sudo -S /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autoprov
    echo $passwd | sudo -S rm /home/$USER/Desktop/ifcx64.cfg
    echo $passwd | sudo -S tar xf /home/$USER/Загрузки/cades-linux-amd64.tar.gz -C /home/$USER/Загрузки/
    echo $passwd | sudo -S rm /home/$USER/Загрузки/cades-linux-amd64.tar.gz
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/cades-linux-amd64/*.deb
    echo $passwd | sudo -S rm -r /home/$USER/Загрузки/cades-linux-amd64
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
    yandex-browser --new-window https://addons.opera.com/ru/extensions/details/cryptopro-extension-for-cades-browser-plug-in/ https://chrome.google.com/webstore/detail/расширение-для-плагина-го/pbefkdcndngodfeigfdgiodgnmbgcfha &
 fi
}

crypto1290(){
    if ! dpkg -s yandex-browser-stable &>/dev/null; then
    $(zenity --info --text="$crypto" --height=300 --width=400)
    else
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета astra-freeipa-client" --text="Подождите, идет установка..." --height=300 --width=400 --auto-close &
    (
    echo $passwd | sudo -S apt install yandex-browser-stable -y
    wget -O /home/$USER/Desktop/crypto1290.tgz https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2Fcrypto1290.tgz
    tar -zxf /home/$USER/Desktop/crypto1290.tgz -C /home/$USER/Desktop/
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S fly-term -e "/home/$USER/Desktop/linux-amd64_deb/install_gui.sh"
    echo $passwd | sudo -S rm /home/$USER/Desktop/crypto1290.tgz
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/linux-amd64_deb
    echo $passwd | sudo -S apt install pcscd -y 
    wget -O /home/$USER/Загрузки/cades-linux-amd64.tar.gz https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2Fcades-linux-amd64.tar.gz
    wget -O /home/$USER/Загрузки/IFCPlugin-x86_64.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=crypto%2FIFCPlugin-x86_64.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S rm /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S ln -s /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
    echo $passwd | sudo -S ln -s /opt/cprocsp/lib/amd64/libcppkcs11.so.4.0.4 /usr/lib/mozilla/plugins/lib/libcppkcs11.so
    wget https://www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg -P /home/$USER/Desktop/
    echo $passwd | sudo -S rm /etc/ifc.cfg
    echo $passwd | sudo -S cp /home/$USER/Desktop/ifcx64.cfg /etc/ifc.cfg
    echo $passwd | sudo -S /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autoprov
    echo $passwd | sudo -S rm /home/$USER/Desktop/ifcx64.cfg
    echo $passwd | sudo -S tar xf /home/$USER/Загрузки/cades-linux-amd64.tar.gz -C /home/$USER/Загрузки/
    echo $passwd | sudo -S rm /home/$USER/Загрузки/cades-linux-amd64.tar.gz
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/cades-linux-amd64/*.deb
    echo $passwd | sudo -S rm -r /home/$USER/Загрузки/cades-linux-amd64
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
    yandex-browser --new-window https://addons.opera.com/ru/extensions/details/cryptopro-extension-for-cades-browser-plug-in/ https://chrome.google.com/we$
    fi
}

kaspersky(){
    if dpkg -l | grep kesl-astra  &>/dev/null; then
    $(zenity --info --text="Касперский уже установлен!" --height=300 --width=400)
    else
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/kesl-astra_11.1.0-3013_amd64.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=kaspersky%2Fkesl-astra_11.1.0-3013_amd64.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/kesl-astra_11.1.0-3013_amd64.deb
    echo $passwd | sudo -S rm /home/$USER/Desktop/kesl-astra_11.1.0-3013_amd64.deb
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/setup.ini
    echo $passwd | sudo -S /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/home/$USER/Desktop/setup.ini
    echo $passwd | sudo -S rm /home/$USER/Desktop/setup.ini
    user=$(zenity --entry --text="Введите имя пользователя, чтобы добавить его в группу администраторов Kaspersky:" --height=300 --width=400)
    echo $passwd | sudo -S usermod -a -G kesluser $user
    echo $passwd | sudo -S kesl-control --grant-role admin $user
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
   fi
}

finereader(){
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S mkdir /opt/finereader/
    echo $passwd | sudo -S wget -O /opt/finereader/ABBYY_Finereader_8_Portable_kmtz.exe https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=FineReader%2FABBYY_Finereader_8_Portable_kmtz.exe
    echo $passwd | sudo -S apt install wine -y
    echo $passwd | sudo -S chmod +x /opt/finereader/ABBYY_Finereader_8_Portable_kmtz.exe
    echo $passwd | sudo -S wget -O /usr/share/applications/flydesktop/finereader.desktop https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Ffinereader.desktop 
    echo $passwd | sudo -S wget -O /usr/share/pixmaps/finereader.png https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=desktop+and+icons%2Ffinereader.png 
        exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
   
}

1c_install(){
    passwd=$(zenity --password)
    check_cancel
    mkdir /home/$USER/Desktop/1c
    $(zenity --info --text="Выберите архив с клиентской частью Предприятия 1с (примерное имя client_8_3_18_1959.deb64.tar.gz) " --height=150 --width=300)
    selected_file_client=$(zenity --file-selection)
    echo $passwd | sudo -S tar -xzf $selected_file_client -C /home/$USER/Desktop/1c
    check_1c=$(ls /home/$USER/1c/ | grep *.run)
    if $check_1c &> /dev/null; then
        # Если есть файлы с расширением .run, выполняем команду
        zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
        (
        echo $passwd | sudo -S /home/$USER/1c/*.run --mode unattended
        exit_code=$?
        echo $passwd | sudo -S rm -r /home/$USER/Desktop/1c
        # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Клиентская составляющая установлена!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке клиентской части."
        fi
        ) | zenity --progress --pulsate --auto-close
    else   
        zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
        (
        echo $passwd | sudo -S apt install libfreetype6 libgsf-1-common unixodbc glib2.0 -y 
        echo $passwd | sudo -S apt install libwebkitgtk-3.0-0
        echo $passwd | sudo -S apt --fix-broken install -y
        echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/1c/1c-enterprise-*-common*_amd64.deb
        echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/1c/1c-enterprise-*-server*_amd64.deb    
        echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/1c/1c-enterprise-*-ws*_amd64.deb  
        echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/1c/1c-enterprise-*-crs_*_amd64.deb
        echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/1c/1c-enterprise-*-client_*_amd64.deb   
        echo $passwd | sudo -S rm -r /home/$USER/Desktop/1c
        # тут мы может указать путь откуда будут скачиваться заранее созданый файл с базами 1с ( он есть в репозитори как пример)
        # echo $passwd | sudo -S wget http://ip-address/share/base1c.sh -P /opt/
        # echo $passwd | sudo -S chmod +x /opt/base1c.sh
        # тут мы добавляем скрипт base1c.sh в автозапуск при входе любого пользователя, и если список базу него пуст, то они пропишуться
        # echo $passwd | sudo -S wget http://ip-address/share/base.desktop -P /etc/xdg/autostart/
        exit_code=$?
        # Проверка кода завершения и отображение соответствующего сообщения
            if [ $exit_code -eq 0 ]; then
                zenity --info --title="Успех" --text="Клиентская составляющая установлена!"
            else
                zenity --error --title="Ошибка" --text="Ошибка при установке клиентской части."
            fi
        ) | zenity --progress --pulsate --auto-close
    fi
}

dinfo_19(){
    passwd=$(zenity --password)
    check_cancel
    (
    echo $passwd | sudo -S mkdir /home/$USER/Desktop/info
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/info/simpledinfo_0-0.5_astra17.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsimpledinfo_0-0.5_astra17.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/info/simpledinfo_0-0.5_astra17.deb
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/info
    echo $passwd | sudo -S wget -O /opt/simpledinfo/settings.ini https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsettings19.ini
    echo $passwd | sudo -S wget -O /etc/xdg/autostart/simpledinfo.desktop https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsimpledinfo.desktop

    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install root-tail   
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
       
}

dinfo_22(){
    passwd=$(zenity --password)
    check_cancel
    (
    echo $passwd | sudo -S mkdir /home/$USER/Desktop/info
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/info/simpledinfo_0-0.5_astra17.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsimpledinfo_0-0.5_astra17.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/info/simpledinfo_0-0.5_astra17.deb
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/info
    echo $passwd | sudo -S wget -O /opt/simpledinfo/settings.ini https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsettings22.ini
    echo $passwd | sudo -S wget -O /etc/xdg/autostart/simpledinfo.desktop https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=simpledinfo%2Fsimpledinfo.desktop

    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install root-tail   
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
       
}

install_virtualbox(){
    passwd=$(zenity --password)
    check_cancel
    (
    echo $passwd | sudo -S wget -O /home/$USER/Desktop/debian.deb https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=repo%2Fdebian.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/debian.deb
    echo $passwd | sudo -S wget -O /etc/apt/sources.list.d/debian.list https://gitflic.ru/project/gabidullin-aleks/packets_for_pomogator/blob/raw?file=repo%2Fdebian.list
    echo $passwd | sudo -S apt update -y
    echo $passwd | sudo -S wget http://easyastra.ru/store/libvpx5.deb -P /home/$USER/Desktop/
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/libvpx5.deb
    echo $passwd | sudo -S rm /home/$USER/Desktop/libvpx5.deb   
    echo $passwd | sudo -S wget http://easyastra.ru/store/virtualbox.deb -P /home/$USER/Desktop/
    echo $passwd | sudo -S dpkg -i /home/$USER/Desktop/virtualbox.deb
    echo $passwd | sudo -S rm /etc/apt/sources.list.d/debian.list
    echo $passwd | sudo -S rm /home/$USER/Desktop/debian.deb
    echo $passwd | sudo -S rm /home/$USER/Desktop/virtualbox.deb
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
}

system_update(){
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка обновления" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S bash -c "echo -e 'deb http://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S apt update -y
    echo $passwd | sudo -S apt install ca-certificates -y
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update -y   
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S astra-update -A -r -T
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Система успешно обновлена!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке обновления."
        fi
    ) | zenity --progress --pulsate --auto-close
}

#-------------------------------------repo function------------------------------------#
repo_stable1_6(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")
    check_cancel    
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/stable/1.6_x86-64/repository smolensk main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/stable/1.6_x86-64/repository-update smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/stable/1.6_x86-64/repository-dev smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/stable/1.6_x86-64/repository-dev-update smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_frozen1_6_12(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")
    check_cancel    
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.6_x86-64/1.6.12/repository smolensk main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.6_x86-64/1.6.12/repository-update/ smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.6_x86-64/1.6.12/repository-dev/ smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb https://dl.astralinux.ru/astra/frozen/1.6_x86-64/1.6.12/repository-dev-update/ smolensk main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_stable1_7(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")
    check_cancel    
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/uu/last/repository-base 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_frozen1_7(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")    
    check_cancel
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-base/ 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-main/ 1.7_x86-64 main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-update/ 1.7_x86-64 main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_debian(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")    
    check_cancel
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian/ buster main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian/ buster-updates main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian-security/ buster/updates main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
}
repo_stable_debian(){
    passwd=$(zenity --forms --title="Пароль для администратора" \
        --text="Введите пароль администратора" \
        --add-password="Пароль")    
    check_cancel
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free' > /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] https://dl.astralinux.ru/astra/stable/1.7_x86-64/uu/last/repository-base 1.7_x86-64 main contrib non-free' >> /etc/apt/sources.list"   
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian/ buster main contrib non-free' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian/ buster-updates main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S bash -c "echo -e 'deb [arch=amd64] http://mirror.yandex.ru/debian-security/ buster/updates main contrib non-free ' >> /etc/apt/sources.list"
    echo $passwd | sudo -S apt update
    $(zenity --info --text="Репозиторий успешно добавлен. Можно проверить по пути /etc/apt/sources.list" --height=200 --width=300)
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
        echo $passwd | sudo -S git clone --depth=1 "https://gitflic.ru/project/gabidullin-aleks/pomogator.git" "$tmp_folder"
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
            $(zenity --question --text "Хотите закрыть приложение для приминения обновления?" --ok-label="Перезапустить" --cancel-label="Отмена" --height=250 --width=200)
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
    news=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=news&inline=false")
    $(zenity --info --text="Вышло обновление приложения $news " --height=400 --width=700)

}

pomogator_version(){
    version=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=version.sh&inline=false")
    trimmed_version=$(echo "$version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
    if [[ $version == *html* ]]; then
    $(zenity --info --text=" У вас нет доступа к репозиторию для обновления" --height=150 --width=300)
    else
        if [[ "$trimmed_version" != "$version_now" ]]; then
            $(zenity --info --text="Вышло обновление "$trimmed_version".\nСпасибо что используете наши технологии" --height=150 --width=300)
            $(zenity --question --text="Хотите посмотреть новвоведения?" --ok-label="Да" --cancel-label="Нет" --height=150 --width=300)
                if [[ $? -eq 0 ]]; then
                newss=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=news&inline=false")
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
            version=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=version.sh&inline=false")
            trimmed_version=$(echo "$version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
                if [[ $version == *html* ]]; then
                $(zenity --info --text=" У вас нет доступа к репозиторию для обновления" --height=150 --width=300)
                else
                    if [[ "$trimmed_version" != "$version_now" ]]; then
                        $(zenity --info --text="Вышло обновление приложения "$trimmed_version".\nСпасибо что используете наши технологии" --height=150 --width=300)
                        $(zenity --question --text="Хотите посмотреть новвоведения?" --ok-label="Да" --cancel-label="Нет" --height=150 --width=300)
                        if [[ $? -eq 0 ]]; then
                        newss=$(curl "https://gitflic.ru/project/gabidullin-aleks/pomogator/blob/raw?file=news&inline=false")
                        $(zenity --info --text="$newss" --height=400 --width=700)
                        fi
                        else
                            $(zenity --info --text="У вас установленно актуальное обновление "$version_now".\nСпасибо что используете наши технологии" --height=150 --width=300)
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
    $(zenity --info --text="$app_info" --height=300 --width=400)
    check_update
    run_menu "${items_main_menu[@]}"
}

#--------------------Запуск программы---------------------------
run_app
