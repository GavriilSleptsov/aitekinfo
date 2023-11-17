#!/bin/bash

# Запускать с правами суперпользователя
# sudo bash script.sh

# Функция для отображения окна ввода текста
input_dialog() {
    zenity --entry --title="$1" --text="$2" --entry-text="$3"
}

# Функция для отображения окна выбора (D/H)
choice_dialog() {
    zenity --list --title="$1" --text="$2" --radiolist --column="" --column="" \
    FALSE "Домен" FALSE "Хост" --column="Выбор"
}

# Функция для отображения информационного окна
info_dialog() {
    zenity --info --title="$1" --text="$2"
}

# Функция для отображения окна подтверждения (Да/Нет)
confirm_dialog() {
    zenity --question --title="$1" --text="$2"
}

aldpro_install() {
    info_dialog "Установка ALDPRO" "Добро пожаловать в установщик ALDPRO!"

    # Получаем данные от пользователя
    HSTNAME=$(input_dialog "Хост" "Введите имя хоста:")
    HOSTIP=$(input_dialog "Хост" "Введите IP текущего хоста:")
    GATEWAY=$(input_dialog "Хост" "Введите gateway:")
    NETMASK=$(input_dialog "Хост" "Введите маску:")
    DNSIP=$(input_dialog "Хост" "Введите IP address dns server:")
    DCIP=$(input_dialog "Хост" "Введите IP домен контроллера:")
    DOMAIN=$(input_dialog "Хост" "Введите имя домена:")
    PASSWORD=$(input_dialog "Хост" "Введите пароль для админа контроллера домена:")
    ACT=$(choice_dialog "Хост" "Настройка домена или ввод хоста в домен?" "Домен")
    
    # Выводим введенные данные для проверки
    info_dialog "Проверка данных" "Проверьте введенные данные:\n\nИмя хоста: $HSTNAME\nIP адрес хоста: $HOSTIP\nGateway: $GATEWAY\nМаска: $NETMASK\nDNS IP: $DNSIP\nIP домена контроллера: $DCIP\nИмя домена: $DOMAIN\nПароль: $PASSWORD\nДействие: $ACT"

    # Записываем изменения в файл
    infok() {
        if [[ $1 ]]; then
            echo -e "Содержание измененного файла $1:\n" >> .log
            cat $1 >> .log
        fi

        echo -e "\n>-----OK\n"
        echo -e "\n-------OK\n" >> .log
    }

    RES="admin"
	if [[ ! -f /etc/apt/preferences.d/aldpro ]]; then 
	
	if [[ $ACT != "H" ]]; then
					while [[ $ACT != "D" ]]
					do
							read -p "Enter D or H :" ACT
							if [[ $ACT == "H" ]]; then
							break
			fi
					done
			fi

	# выводим введённые данные для проверки
			echo -e "\nhostname: $HSTNAME\nIP address: $HOSTIP\ngameway: $GATEWAY\ndns IP address: $DNSIP\nIP address DC: $DCIP\ndomain: $DOMAIN\npassword: $PASSWORD\nНастройка домена(D) или хоста(H): $ACT\n"

			read -p "Данные введены корректно ? " RES

	# сохраняем введённые данные для второго этапа установки скрипта
	cat <<EOF > .varForDCstp
export HSTNAME=$HSTNAME
export HOSTIP=$HOSTIP
export GATEWAY=$GATEWAY
export NETMASK=$NETMASK
export DNSIP=$DNSIP
export DOMAIN=$DOMAIN
export PASSWORD=$PASSWORD
export ACT=$ACT
export DCIP=$DCIP
EOF

	# изменяем hostname
			info "изменяем hostname"
			echo "$HSTNAME.$DOMAIN" > /etc/hostname
			infok /etc/hostname

	# изменяем hosts
			info "изменяем hosts"
			IFS=" "
			SH=$(tail -n 5 /etc/hosts)
	cat <<EOF > /etc/hosts
127.0.0.1       localhost
$HOSTIP         $HSTNAME.$DOMAIN       $HSTNAME
EOF
			echo $SH >> /etc/hosts
			infok /etc/hosts

	# добавляем репозитории Astra Linux
			#while IFS= read -r line
			#do
			#       echo "#$line" >> /etc/apt/sources.list
			#done < /etc/apt/sources.list

			info "добавляем репозитории Astra Linux"
			echo -e "\ndeb http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base 1.7_x86-64 main non-free contrib" | sudo tee /etc/apt/sources.list
			echo -e "deb http://download.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended 1.7_x86-64 main contrib non-free" | sudo tee -a /etc/apt/sources.list
			infok /etc/apt/sources.list

	# добавляем репоизтории ALDPRO
			info "добавляем репоизтории ALDPRO"
			echo "deb https://download.astralinux.ru/aldpro/stable/repository-main/ 2.1.0 main" >> /etc/apt/sources.list.d/aldpro.list
			echo "deb https://download.astralinux.ru/aldpro/stable/repository-extended/ generic main" >> /etc/apt/sources.list.d/aldpro.list
			infok /etc/apt/sources.list.d/aldpro.list

	# добавляем конфигурационный файл для ALDPRO
			info "добавляем конфигурационный файл для ALDPRO"
	cat <<EOF > /etc/apt/preferences.d/aldpro
	Package: *
	Pin: release n=generic
	Pin-Priority: 900
EOF
			infok /etc/apt/preferences.d/aldpro

	# обновляем пакеты из репозиториев
			info "обновляем пакеты из репозиториев"
			echo -e "\n"
			sudo apt update && sudo apt dist-upgrade -y  #&>> .log 
			infok

	# отключаем службу NetworkManager
			info "отключаем службу NetworkManager"
			echo -e "\n"
			stp="stop"
			sudo systemctl $stp NetworkManager  #&>> .log
			sudo systemctl disable NetworkManager  #&>> .log
			sudo systemctl mask NetworkManager  #&>> .log
			infok

	# изменяем конфигурационный файл interfaces домена контроллера
	if [[ $ACT == "D" ]]; then
			info "изменяем конфигурационный файл interfaces для DC"
	cat <<EOF >> /etc/network/interfaces
	auto eth0
	iface eth0 inet static
		address $HOSTIP
		netmask $NETMASK
		gateway $GATEWAY
		dns-nameservers $DNSIP
		dns-search $DOMAIN
EOF
			infok /etc/network/interfaces

	# изменяем конфигурационный файл хоста при вводе в домен
	else
			info "изменяем конфигурационный файл interfaces при вводе в DC"
	cat <<EOF >> /etc/network/interfaces
	auto eth0
	iface eth0 inet static
		address $HOSTIP
		netmask $NETMASK
		gateway $GATEWAY
		dns-nameservers $DCIP
		dns-search $DOMAIN
EOF
			infok /etc/network/interfaces
	fi

	# изменяем конфигурационный файл resolv при вводе хоста в домен
			if [[ $ACT == "H" ]]; then
					info "изменяем конфигурационный файл resolv при вводе в DC"
					echo "nameserver $DCIP" > /etc/resolv.conf
					echo "search $DOMAIN" >> /etc/resolv.conf
					infok /etc/resolv.conf
			fi

	# информационное сообщение перед перезагрузкой
			read -p "Перезагрузите компьютер. Запустите скрипт снова из той же папки!" RES
			#read -p "Перезагрузите компьютер. Запустите скрипт снова из той же папки! Логи сохраняются в папке со скриптом файл .log" RES
			exit




	else     ######################----- ВТОРОЙ ЭТАП УСТАНОВКИ ПОСЛЕ ПЕРЕЗАГРУЗКИ -----######################
			echo -e "\n>-------ВТОРОЙ ЭТАП УСТАНОВКИ ПОСЛЕ ПЕРЕЗАГРУЗКИ-------<" >> .log
	# восстанавливаем нужные данные из временного файла введённые при первом запуске скрипта.
			source .varForDCstp

	# устанавливаем необходимые пакеты для ALDPRO
			if [[ $ACT == "D" ]]; then
					info "устанавливаем необходимые пакеты для ALDPRO для DC"
					echo -e "\n"
					sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y aldpro-mp
					infok 

	# устанавливаем необходимые пакеты для хоста при вводе в домен (клиент)
			else
					info "устанавливаем необходимые пакеты для ALDPRO при вводе хоста в домен"
					echo -e "\n"
					sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y aldpro-client
					infok 
			fi

	# изменяем в interfaces dns-nameservers на 127.0.0.1 при настройке контроллера домена
			if [[ $ACT == "D" ]]; then
					info "изменяем в interfaces dns-nameservers на 127.0.0.1 для DC"
					IFS=" "
					str=$(cat /etc/network/interfaces)
					res=${str//dns-nameservers $DNSIP/dns-nameservers 127.0.0.1}
					echo $res > /etc/network/interfaces
					sudo systemctl restart networking  #&>> .log
					infok /etc/network/interfaces
			fi

	# изменяем конфигурационный файл resolv при настройке контроллера домена
			if [[ $ACT == "D" ]]; then
					info "изменяем конфигурационный файл resolv для DC"
					echo "nameserver 127.0.0.1" > /etc/resolv.conf
					echo "search $DOMAIN" >> /etc/resolv.conf
					infok /etc/resolv.conf
			fi

	# выполняем настройку контроллера домена
			if [[ $ACT == "D" ]]; then
					info "выполняем настройку контроллера домена"
					echo -e "\n"
					sudo /opt/rbta/aldpro/mp/bin/aldpro-server-install.sh -d $DOMAIN -n $HSTNAME -p $PASSWORD --ip $HOSTIP --no-reboot
					infok

	# выполняем ввод хоста в домен
			else
					info "выполняем настройку хоста для ввода в домен"
					echo -e "\n"
					sudo /opt/rbta/aldpro/client/bin/aldpro-client-installer -c $DOMAIN -u admin -p $PASSWORD -d $HSTNAME -i -f
					infok
			fi
	# удаляем временные файлы
	#rm .varForDCstp

	# последнее информационное сообщение при настройке контроллера домена 
			if [[ $ACT == "D" ]]; then
					echo "Введённые данные содержаться в файле .varForDCstp, который находится в папке со скриптом."
					echo "Содержание изменённых файлов и ход выполнения скрипта содержатся в файле .log, который находится в папке со скриптом."
					read -p "Перезагрузите компьютер. Доступ к админке через браузер (https://$HSTNAME.$DOMAIN) " RES

	# последнее информационное сообщение при вводе хоста в домен
			else
					echo "Введённые данные содержаться в файле .varForDCstp, который находится в папке со скриптом."
					echo "Содержание изменённых файлов и ход выполнения скрипта содержатся в файле .log, который находится в папке со скриптом."
					read -p "Перезагрузите компьютер. Залогинтесь под зарегистрированным пользователем " RES
			fi

	fi

    # Выводим информационное окно перед перезагрузкой
    confirm_dialog "Перезагрузка" "Перезагрузите компьютер. Запустите скрипт снова из той же папки!"
}

# Вызываем функцию для установки ALDPRO
aldpro_install
