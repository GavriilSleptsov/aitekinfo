declare -A event_menu
install_app_myoffice() {
    passwd=$(zenity --password)
    check_cancel
    wget https://slepsov.ru/aitekinfo/myoffice-standard-documents_2.6.0_amd64.deb -P /home/$USER/Desktop/
    file="/home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb"
    
    # Установка пакета с указанием прогресса
    zenity --progress --title="Установка пакета" --text="Подождите, идет установка..." --percentage=0 --auto-kill &
    progress=$!

    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install -f "$file" -y
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
    if [ $exit_code -eq 0 ]; then
        echo 100
        zenity --info --title="Успех" --text="Пакет успешно установлен!"
    else
        echo 100
        zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
    fi
    ) | (
        # Цикл для обновления значения прогресса
        while read -r value; do
            echo $value
        done
        # Завершение цикла, когда значение достигает 100
        ) | zenity --progress --title="Установка пакета" --text="Подождите, идет установка..." --percentage=0 --auto-close

    rm /home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb
}