path=/opt/aitekinfo
path_items=/opt/aitekinfo/item_menu
path_events=/opt/aitekinfo/event_item_menu
path_install_functions=/opt/aitekinfo/install_functions
source $path/version.sh
source $path/date_last_update.sh
exit_app="Выход"
exit_menu="Назад"
selected_item_menu=""
app_info="Программа помощник: Помогатор АйтекИнфо\n\nВерсия: "$version_now"\n\nДата последнего обновления: "$date_last_update"\n"
crypto="Для работы с сайтами использующими ЭЦП для подтверждения входа необходимо устанвить Яндекс браузер!" 
papki="1.Необходимо перезайти в сессию.\n2. Перезагрузить ПК.\n3. Зайти в учетную запись имяпользователя@domain.name и пароль от windows прошлый ( если пароль устарел сменить его на новый)"