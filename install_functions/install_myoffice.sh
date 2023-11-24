declare -A event_menu
install_app_myoffice() {
    passwd=$(zenity --password)
    check_cancel
    url="https://slepsov.ru/aitekinfo/myoffice-standard-documents_2.6.0_amd64.deb"
    file="/home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb"

    # Запуск wget в фоновом режиме для загрузки файла с отображением прогресса
    wget --progress=bar:force -O "$file" "$url" 2>&1 | \
    stdbuf -oL awk -v var="$file" '/[0-9]+%/ {gsub(/\r/, "", $2); print int($2)}' | \
    zenity --progress --title="Загрузка файла" --text="Подождите, идет загрузка..." --percentage=0 --auto-close

    # Проверка кода завершения wget
    if [ $? -eq 0 ]; then
        zenity --info --title="Успех" --text="Файл успешно загружен!"
    else
        zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
        exit 1
    fi
    
    # Установка пакета с указанием прогресса
    zenity --progress --title="Установка пакета" --text="Подождите, идет установка..." --percentage=0 &
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

    rm "$file"
}