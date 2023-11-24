declare -A event_menu
install_app_myoffice() {
    passwd=$(zenity --password)
    check_cancel
    url="https://slepsov.ru/aitekinfo/myoffice-standard-documents_2.6.0_amd64.deb"
    file="/home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb"

    # Запуск wget в фоновом режиме для загрузки файла с отображением прогресса
    wget --progress --pulsate -O "$file" "$url" 2>&1 | \
    zenity --progress --title="Загрузка файла" --text="Подождите, идет загрузка..." --auto-close
    # Проверка кода завершения wget
    if [ $? -eq 0 ]; then
        zenity --info --title="Успех" --text="Файл успешно загружен!"
    else
        zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
    fi
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
    rm /home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb
}