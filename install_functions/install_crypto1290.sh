install_app_crypto1290(){
    if ! dpkg -s yandex-browser-stable &>/dev/null; then
    $(zenity --info --text="$crypto" --height=300 --width=400)
    else
    passwd=$(zenity --password)
    check_cancel
    zenity --auto-close &
    (
    echo $passwd | sudo -S apt install yandex-browser-stable -y
    wget -O /home/$USER/Desktop/crypto1290.tgz https://slepsov.ru/aitekinfo/crypto1290.tgz
    tar -zxf /home/$USER/Desktop/crypto1290.tgz -C /home/$USER/Desktop/
    # Установка пакета с использованием sudo и передачей пароля через stdin
    echo $passwd | sudo -S fly-term -e "/home/$USER/Desktop/linux-amd64_deb/install_gui.sh"
    echo $passwd | sudo -S rm /home/$USER/Desktop/crypto1290.tgz
    echo $passwd | sudo -S rm -r /home/$USER/Desktop/linux-amd64_deb
    echo $passwd | sudo -S apt install pcscd -y 
    wget -O /home/$USER/Загрузки/cades-linux-amd64.tar.gz https://slepsov.ru/aitekinfo/cades-linux-amd64.tar.gz
    wget -O /home/$USER/Загрузки/IFCPlugin-x86_64.deb https://slepsov.ru/aitekinfo/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S rm /home/$USER/Загрузки/IFCPlugin-x86_64.deb
    echo $passwd | sudo -S ln -s /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
    echo $passwd | sudo -S ln -s /opt/cprocsp/lib/amd64/libcppkcs11.so.4.0.4 /usr/lib/mozilla/plugins/lib/libcppkcs11.so
    wget https://www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg -P /home/$USER/Desktop/
    echo $passwd | sudo -S rm /etc/ifc.cfg
    echo $passwd | sudo -S cp /home/$USER/Desktop/ifcx64.cfg /etc/ifc.cfg
    echo $passwd | sudo -S /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autoprov
    echo $passwd | sudo -S rm /home/$USER/Desktop/ifcx64.cfg
    echo $passwd | sudo -S tar xf /home/$USER/Загрузки/cades-linux-amd64.tar.gz -C /home/$USER/Загрузки/
    echo $passwd | sudo -S rm /home/$USER/Загрузки/cades-linux-amd64.tar.gz
    echo $passwd | sudo -S dpkg -i /home/$USER/Загрузки/cades-linux-amd64/*.deb
    echo $passwd | sudo -S rm -r /home/$USER/Загрузки/cades-linux-amd64
    exit_code=$?
    # Проверка кода завершения и отображение соответствующего сообщения
        if [ $exit_code -eq 0 ]; then
            zenity --info --title="Успех" --text="Пакет успешно установлен!"
        else
            zenity --error --title="Ошибка" --text="Ошибка при установке пакета."
        fi
    ) | zenity --progress --pulsate --title "Установка пакета" --text="Подождите, идет установка пакета..." --auto-close
    fi
}
