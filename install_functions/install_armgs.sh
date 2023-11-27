install_app_armgs() {
	file_path="/usr/share/applications/wps-office-prometheus.desktopasdsad"
	if [ -e "$file_path" ]; then
		zenity --info --text="Пакет уже установлен!"
		check_cancel
	else 
		passwd=$(zenity --password)
		check_cancel
		file="/home/$USER/Desktop/armgs.tar.xz"
		zenity --auto-close &
		(
			wget https://drive.usercontent.google.com/download?id=18GuRwjuz_nx94lSNQELrmFv1Mpm8H2Ct&export=download&authuser=0&confirm=t&uuid=c712b547-4568-4c7e-8cd9-9749afdf06e9&at=APZUnTX8BlCxQ_F40MZtqmY0Q-MU:1701062602792 -P /home/$USER/Desktop/
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
			echo $passwd | sudo -Ss apt install "$file" -y -q
			# Получение кода завершения установки
			exit_code=$?
			# Проверка кода завершения и отображение соответствующего сообщения
			if [ $exit_code -eq 0 ]; then
				zenity --info --title="Успех" --text="Пакет успешно установлен!"
				#cp $file_path /home/$USER/Desktop
			else
				zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
			fi
		) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка..." --auto-close
		# Проверка наличия файла перед удалением
		if [ -e "$file" ]; then
			rm "$file"
		fi
	fi
}