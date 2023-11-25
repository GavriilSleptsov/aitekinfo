declare -A event_menu
install_app_remmina() {
    passwd=$(zenity --password)
    check_cancel
    # Установка пакета с указанием прогресса
    zenity --auto-close &
    (
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S apt install remmina -y
    # Получение кода завершения установки
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --title "Установка пакета" --text "Подождите, идет установка пакета..." --auto-close
}