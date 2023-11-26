install_app_telegram() {
    passwd=$(zenity --password)
    check_cancel
	
	file_path="/usr/share/applications/telegram.desktop"
	
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		exit 1
	else 
		file="/home/$USER/Desktop/telegram.deb"
		zenity --auto-close &
		(
			wget http://easyastra.ru/store/telegram.deb -P /home/$USER/Desktop/
			
			# Проверка кода завершения wget
			if [ $? -eq 0 ]; then
				zenity --info --title="Успех" --text="Файл успешно загружен!"
			else
				zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
				exit 1
			fi
		) | zenity --progress --pulsate --title "Загрука пакета" --text="Подождите, идет загрука..." --auto-close
		
		# Установка пакета
		zenity --auto-close &
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
		) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка..." --auto-close

		rm "$file"
}
