install_app_finereader(){
    passwd=$(zenity --password)
    check_cancel
    zenity --progress --pulsate --title="Установка пакета" --text="Подождите, идет установка..." --auto-close &
    (
    echo $passwd | sudo -S mkdir /opt/finereader/
    echo $passwd | sudo -S wget -O /opt/finereader/ABBYY_Finereader_8_Portable_kmtz.exe https://slepsov.ru/aitekinfo/ABBYY_Finereader_8_Portable_kmtz.exe
    #echo $passwd | sudo -S apt install wine -y
    echo $passwd | sudo -S chmod +x /opt/finereader/ABBYY_Finereader_8_Portable_kmtz.exe
    echo $passwd | sudo -S wget -O /usr/share/applications/flydesktop/finereader.desktop https://slepsov.ru/aitekinfo/finereader.desktop
    echo $passwd | sudo -S wget -O /usr/share/pixmaps/finereader.png https://slepsov.ru/aitekinfo/finereader.png
        exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --auto-close
   
}