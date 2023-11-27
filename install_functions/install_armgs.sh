install_app_armgs() {
	file_path="/opt/armgs/armgs"
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		check_cancel
	else 
		passwd=$(zenity --password)
		check_cancel
		file="/opt/armgs/"
		zenity --auto-close &
		(
			wget https://dl.armgs.team/downloads/linux/x64/latest/armgs.tar.xz -P $file
			# Проверка кода завершения wget
			if [ $? -eq 0 ]; then
				zenity --info --title="Успех" --text="Файл успешно загружен!"
			else
				zenity --error --title="Ошибка" --text="Ошибка при загрузке файла."
				exit 1
			fi
		) | zenity --progress --pulsate --title "Загрузка пакета" --text="Подождите, идет загрузка..." --auto-close
		
		# Установка пакета
		zenity --auto-close &
		(
			# Установка пакета с использованием sudo и передачей пароля через stdin
			tar -xf /opt/armgs/armgs.tar.xz
			rm -r armgs.tar.xz
			
			# Получение кода завершения установки
			#exit_code=$?
			# Проверка кода завершения и отображение соответствующего сообщения
			#if [ $exit_code -eq 0 ]; then
			#	zenity --info --title="Успех" --text="Пакет успешно установлен!"
				#cp $file_path /home/$USER/Desktop
			#else
			#	zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
			#fi
		) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка..." --auto-close
		# Проверка наличия файла перед удалением
	fi
}

