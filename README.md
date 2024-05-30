------------------------------------
### Чек-лист готовности к выполнению дипломной работы

1.  Установлена PostgreSQL 15 версии.
 ```bash
psql --version
psql (PostgreSQL) 15.6 (Ubuntu 15.6-1.pgdg22.04+1)
 ```
2. Запущен экземпляр базы данных в режиме «чтение/запись».
Установлена БД Diplom. 
3. СУБД настроена на приём только безопасных соединений от клиентов.
``` bash
# был настроен Мастер repmgr. Конфиг настройки прикладываю. 
postgres@student:~$ repmgr -f /etc/repmgr/15/repmgr.conf primary register
INFO: connecting to primary database...
NOTICE: attempting to install extension "repmgr"
NOTICE: "repmgr" extension successfully installed
NOTICE: primary node record (ID: 1) registered
# Все пароли и данные к БД находятся в .pgpass
# Настроен pgbouncer. Конфиги в каталоге. pgbouncer.ini , uselist.txt
# настроено бекапирование c помощью pg_dump. Настроен cron для ежеднемного снятия копии.
pg_dump -h 192.168.68.105 -U admin -d Diplom -w > ./backup/backup_$(date +"%Y-%m-%d").sql
#Настроено логирование. 

```
------


30.05.2024

1. Удалены все роли с русскими названиями;
2. Приведены в соответсвие роли созданные с помощью скрипта create_role.py
3. Изменена процедура для выгрузки xml файла. Было создано табличное представление для формирования данных процедуры. 
4. Изменён скрипт mail_send.py на generate_and_download_xml.py. 
5. Создан скрипт delete_old_archives.py для удаления wal архивов старше 40 дней. 
6. Создан word фаил с описанием диплома. 
