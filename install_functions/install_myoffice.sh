install_app_myoffice() {
	file_path="/usr/share/applications/myoffice-text.desktop"
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		check_cancel
	else 
		passwd=$(zenity --password)
		check_cancel
		file="/home/$USER/Desktop/myoffice-standard-documents_2.6.0_amd64.deb"

		zenity --auto-close &
		(
			wget https://slepsov.ru/aitekinfo/myoffice-standard-documents_2.6.0_amd64.deb -P /home/$USER/Desktop/
			
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
			echo $passwd | sudo -S apt install "$file" -y
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
	fi
}
