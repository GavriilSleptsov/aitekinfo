#!/bin/bash
if dpkg -s git  &>/dev/null; then
   if dpkg -s curl  &>/dev/null; then
    $(zenity --info --text "Вас приветствует программа установки приложения АйтекИнфо! В следующем окошке введите пароль от администратора!" --height=150 --width=300)
    passwd=$(zenity --forms --title="Пароль для администратора" \
            --text="Введите пароль администратора" \
            --add-password="Пароль")
    echo "$passwd" | sudo -Sv >/dev/null 2>&1
        if [ $? -eq 0 ]; then
        zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
        (
        echo $passwd | sudo -S git clone --depth=1 https://github.com/GavriilSleptsov/aitekinfo.git /opt/aitekinfo
        echo $passwd | sudo -S chmod +x -R /opt/aitekinfo
        echo $passwd | sudo -S cp /opt/aitekinfo/aitekinfo.desktop -P /usr/share/applications/flydesktop/
        echo $passwd | sudo -S cp /opt/aitekinfo/aitekinfo_icon.jpg -P /usr/share/pixmaps/
        exit_code=$?
            # Проверка кода завершения и отображение соответствующего сообщения
            if [ $exit_code -eq 0 ]; then
                $(zenity --info --title="Успех" --text="Приложение АйтекИнфо успешно установлено!" --height=150 --width=300)
            else
                zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
            fi
            ) | zenity --progress --pulsate --auto-close
        else
        $(zenity --info --text "Неверный пароль администратора! Или у вас не хватает прав!" --height=150 --width=300)
        exit 0
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
            zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
            (
            echo $passwd | sudo -S apt install curl -y
            exit_code=$?
            # Проверка кода завершения и отображение соответствующего сообщения
            if [ $exit_code -eq 0 ]; then
                $(zenity --info --title="Успех" --text="Пакет успешно установлен! Запустите установщик повторно для проверки зависимостей!" --height=150 --width=300)
            else
                zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
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
            zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
            (
            echo $passwd | sudo -S apt install git -y
            exit_code=$?
            # Проверка кода завершения и отображение соответствующего сообщения            
            if [ $exit_code -eq 0 ]; then
                $(zenity --info --title="Успех" --text="Пакет успешно установлен! Запустите установщик повторно для проверки зависимостей!" --height=150 --width=300)
            else
                zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
            fi
            ) | zenity --progress --pulsate --auto-close
            else
            $(zenity --info --text "Неверный пароль администратора! Или у вас не хватает прав!" --height=150 --width=300)
            fi
        else
            exit 0
        fi
fi
