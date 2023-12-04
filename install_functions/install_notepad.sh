install_app_notepad() {
	file_path="/usr/share/applications/notepad.desktop"
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		check_cancel
	else 
		passwd=$(zenity --password)
		check_cancel
		file="/home/$USER/Desktop/notepadplus.deb"
		zenity --auto-close &
		(
			wget http://easyastra.ru/store/notepadplus.deb -P /home/$USER/Desktop/
			# Проверка кода завершения wget
			if [ $? -eq 0 ]; then
				zenity --info --title="Успех" --text="Файл успешно загружен!"
			else
				zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
				exit 1
			fi
		) | zenity --progress --pulsate --title "Загрузка пакета" --text="Подождите, идет загрузка..." --auto-close
		
		# Установка пакета
		if [ $? -eq 0 ]; then
			zenity --auto-close &
		(
			# Установка пакета с использованием sudo и передачей пароля через stdin
			echo $passwd | sudo -S apt install "$file" -y
			# Получение кода завершения установки
			exit_code=$?
			# Проверка кода завершения и отображение соответствующего сообщения
			if [ $exit_code -eq 0 ]; then
				zenity --info --title="Успех" --text="Пакет успешно установлен!"
				cp $file_path /home/$USER/Desktop
			else
				zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
			fi
		) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка..." --auto-close
		else
			return
		fi
		# Проверка наличия файла перед удалением
		if [ -e "$file" ]; then
			rm "$file"
		fi
	fi
}