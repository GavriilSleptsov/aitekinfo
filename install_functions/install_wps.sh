install_app_wps() {
    file_path="/usr/share/applications/wps-office-prometheus.desktop"

    if [ -e "$file_path" ]; then
        zenity --info --text="Пакет уже установлен!"
        return
    fi

    passwd=$(zenity --password)
    file="/home/$USER/Desktop/wps-office.deb"

    zenity --info --title="Успех" --text="Файл успешно загружен!" \
        < <(wget http://easyastra.ru/store/wps-office.deb -P /home/$USER/Desktop/ 2>&1)

    # Проверка кода завершения wget
    if [ $? -ne 0 ]; then
        zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
        return
    fi

    zenity --info --title="Установка" --text="Идет установка пакета..." \
        < <(echo $passwd | sudo -Ss apt install "$file" -y -q 2>&1)

    # Проверка кода завершения установки
    if [ $? -eq 0 ]; then
        zenity --info --title="Успех" --text="Пакет успешно установлен!"
        #cp $file_path /home/$USER/Desktop
    else
        zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
    fi

    # Проверка наличия файла перед удалением
    if [ -e $file ]; then
        rm $file
    fi
}