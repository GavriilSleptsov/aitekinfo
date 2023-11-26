install_app_yandex() {
	file_path="/usr/share/applications/yandex-browser.desktop"
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		check_cancel
	else 
		passwd=$(zenity --password)
		check_cancel
		# Установка пакета с указанием прогресса
		zenity --auto-close &
		(
		# Установка пакета с использованием sudo и передачей пароля через stdin
		echo $passwd | sudo -S apt install yandex-browser-stable -y
		# Получение кода завершения установки
		exit_code=$?
		# Проверка кода завершения и отображение соответствующего сообщения
			if [ $exit_code -eq 0 ]; then
				zenity --info --title="Успех" --text="Пакет успешно установлен!"
				cp $file_path /home/$USER/Desktop
			else
				zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
			fi
		) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка пакета..." --auto-close
	fi
}