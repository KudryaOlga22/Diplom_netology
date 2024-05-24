

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

